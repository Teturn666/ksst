import { ArrayList, HashMap, LinkedList, List, TreeMap, TreeSet } from '@kit.ArkTS'
import { QuestionRes, questionTable } from 'db/Index'
import { Logger, StringUtils } from 'utils/Index'
import { SegmentEngine } from './SegmentEngine'
import { taskpool } from '@kit.ArkTS';

import { StringFilter } from './StringFilter'
import { QuestionBean } from '../model/QuestionBean';
import systemDateTime from '@ohos.systemDateTime';
import SearchConstants from '../constants/SearchConstants'

// TODO taskpool涉及到参数序列化，SearchEngine会提示参数序列化失败
// @Concurrent
// async function initSearchEngine(engine:SearchEngine): Promise<boolean>{
//   await engine.initWithThreadTask();
//   return engine.mIsInitFinish
// }

export class SearchEngine {
  private static delegate = new SearchEngine()
  private mDataTexts: HashMap<string, TreeSet<number>> = new TreeMap()
  private questionList: ArrayList<QuestionRes> = new ArrayList<QuestionRes>()
  private mDataSize = 0;
  mIsInitFinish = false
  private mStopWords = "\t1234567890【】，。,.、  ？?_;；：:…'\"\nABCD"
  private static MIN_SCORE = 0.001

  private constructor() {
  }

  public static getInstance(): SearchEngine {
    return SearchEngine.delegate
  }

  // static initEngine(){
  //   taskpool.execute(initSearchEngine,SearchEngine.getInstance()).then((res:object)=>{
  //     Logger.debug("搜索引擎初始化结果："+res)
  //   })
  // }

  // //获取题目表
  // public setQuestionTable(questionTable: QuestionTable) {
  //   this.mQuestionTable = questionTable
  // }

  //查找题目表数据库所有的数据
  private findAllQuestionData() {
    questionTable?.query(0, (result: List<QuestionRes>) => {
      Logger.info('题目表获取到的数据====>' + result.length + "====>" + result[0].id + result[0].questionCase +
        "====>" + result[1].id + result[1].questionCase)
      this.questionList.clear()
      result.forEach((resultElement) => {
        this.questionList.add(resultElement)
      })
      Logger.info('=====' + this.questionList.length)
    }, true)
  }

  /**
   * 查找题目表数据库所有的数据
   * @param callback true-有数据 false-无数据
   */
  private async findAllQuestionDataSync(): Promise<boolean> {
    let questions = await questionTable?.querySync(0, true) ?? []
    this.questionList.clear()

    questions.forEach((resultElement) => {
      this.questionList.add(resultElement)
    })
    return this.questionList.length != 0
  }

  /**
   * 从数据库初始化数据并判断是否需要初始化搜索引擎
   */
  private async indexFromDatabase(): Promise<boolean> {
    let res = await this.findAllQuestionDataSync() ?? false
    if (res) {
      let startTime = systemDateTime.getTime();
      Logger.debug("开始初始化引擎：" + startTime)
      await this.initEngine()
      this.mIsInitFinish = true
      Logger.debug('搜索引擎初始化完成' + (systemDateTime.getTime() - startTime) + "ms")
      return true
    } else {
      this.mIsInitFinish = false
      return false
    }
  }

  /**
   * 初始化搜索引擎
   */
  private async initEngine() {
    this.mDataTexts.clear()
    this.mDataSize = this.questionList.length

    this.questionList.forEach((item) => {
      // 题目提取的文字内容
      let str = item.question + item.option.join()
      if (!StringUtils.isNullOrEmpty(str)) {
        //分词
        let list = SegmentEngine.getInstance().cut(str)
        list.forEach((key: string) => {
          if (this.mStopWords.search(key) != -1) {
            return
          }
          let textList = new TreeSet<number>()
          if (this.mDataTexts.hasKey(key)) {
            textList = this.mDataTexts.get(key)
          }
          // textList.add(item.id)
          this.mDataTexts.set(key, textList)
        })
      }
    })
  }

  //TODO 这个方法还得完善，差单线程
  private initWithThread() {
    //TODO 开启单线程
    // let task = new taskpool.Task(this.initWithThreadTask())
    // taskpool.execute(task, taskpool.Priority.HIGH).then(() => {
    //
    // })

    this.initWithThreadTask()
  }

  // @Concurrent
  async initWithThreadTask(): Promise<boolean> {
    this.mIsInitFinish = false
    return await this.indexFromDatabase()
    // this.mIsInitFinish = true
  }


  //TODO 差单线程，异步获取最匹配的一个问题
  /**
   * 返回一个最匹配的结果
   * @param qStr 搜索内容
   * @returns 返回结果
   */
  public async queryTextWithIndexInThread(qStr: string): Promise<QuestionRes | null> {
    if (!this.mIsInitFinish) {
      Logger.error("搜索引擎初还未初始化完成")
      return null
    }
    try {
      let id = await SearchEngine.getInstance().searchTextWithIndex(qStr)
      if (id === -1) {
        return null
      } else {
        let result = await questionTable?.querySync(id, false) ?? []
        Logger.info('题目表获取到的数据====>' + result.length)
        if (result.length > 0) {
          return result[0]
        }
      }
    } catch (e) {
      return null
    }

    return null
  }

  private async searchTextWithIndex(q: string): Promise<number> {
    let mMatchScores = new TreeMap<number, number>()
    if (!StringUtils.isNullOrEmpty(q)) {
      let list = SegmentEngine.getInstance().cut(q)
      list.forEach((key: string) => {
        if (this.mStopWords.search(key) != -1) {
          return
        }
        let ids = this.mDataTexts.get(key)
        if (ids != null && ids.length > 0) {
          ids.forEach((id: number) => {
            let score = mMatchScores.get(id) == null ? 0.0 : mMatchScores.get(id)

            score += Math.log10(this.mDataSize / ids.length)
            mMatchScores.set(id, score)
          })

        }

      })
    }
    //获取 top5
    let topN = 5
    let topList = new LinkedList<TopItem>()
    mMatchScores.forEach((value: number, key: number): void => {
      if (topList.length === 0) {
        let item = new TopItem()
        item.id = key
        item.score = value
        topList.add(item)
      } else {
        let isAdd = false
        for (let i = 0; i < topList.length; i++) {
          if (value > topList[i].score) {
            let item = new TopItem()
            item.id = key
            item.score = value
            topList.set(i, item)
            isAdd = true
            return
          }
        }
        if (!isAdd && value > SearchEngine.MIN_SCORE) {
          let item = new TopItem()
          item.id = key
          item.score = value
          topList.add(item)
        }
        while (topList.length > topN) {
          topList.removeLast()
        }
      }

    })
    //处理 top5
    let maxVal = -1
    let id = -1
    let maxLcs = -1

    for (let topListElement of topList) {
      let result = await questionTable?.querySync(topListElement.id, false) ?? []
      Logger.info('题目表获取到的数据====>' + result.length)
      let qs: QuestionRes | null = null;
      if (result.length > 0) {
        qs = result[0]
      }
      let ss = ""
      if (qs != null) {
        ss = qs.question + qs.answer
      }
      let lcsVal = this.lcs(q, ss)
      if (maxLcs < lcsVal) {
        maxLcs = lcsVal
      }
      let score = topListElement.score * lcsVal * 1.0 / ss.length
      if (score > maxVal) {
        id = topListElement.id
        maxVal = score
      } else if (score == maxVal && topListElement.id > id) {
        id = topListElement.id
        maxVal = score
      }
    }

    // Logger.info("max score:" + maxVal + ", max lcs:" + maxLcs);
    // TODO 这个系数需要根据情况调整
    if (maxVal <= 0.1) {
      return -1
    }
    return id
  }

  /**
   * 获取题目拼接的数据，读屏搜题会用到
   * @param q 检索字符串
   * @returns 结果
   */
  private async fetchTop1Question(q: string): Promise<Array<QuestionBean> | null> {
    if (!this.mIsInitFinish) {
      Logger.error("搜索引擎初还未初始化完成")
      return null;
    }
    let qStr = StringFilter.formatString(q);
    let id = await this.searchTextWithIndex(qStr);
    let questions = new Array<QuestionBean>()
    let result = await questionTable?.querySync(id, false) ?? []
    Logger.info('题目表获取到的数据====>' + result.length)
    if (result.length > 0 && result[0] != null) {
      let record: QuestionRes = result[0]
      const qItem = new QuestionBean()
      qItem.q = "【" + record.answer + "】" + record.question
      let options = record.option
      options.forEach((optionsElement) => {
        qItem.a.add(optionsElement)
      })
      questions.push(qItem)
    }
    return questions
  }

  /**
   * 获取拼接后的题目数据（读屏搜题）
   * @param q
   * @param callback
   */
  async queryTextWithIndexInThreadTwo(q: string): Promise<Array<QuestionBean>> {
    try {
      let questions = await this.fetchTop1Question(q) ?? []
      return questions;
    } catch (e) {
      return []
    }
  }

  /**
   * 异步方法，根据输入内容获取
   * @param q
   * @returns
   */
  public async queryQuestionsWithText(q: string): Promise<Array<QuestionRes>> {
    try {
      let questions = await this.fetchQuestions(q)
      return questions
    } catch (e) {
      return []
    }
  }

  //查找相似题目
  private async fetchQuestions(q: string): Promise<QuestionRes[]> {
    if (!this.mIsInitFinish) {
      Logger.error("搜索引擎初还未初始化完成")
      return [];
    }
    let qStr = StringFilter.formatString(q)
    let ids = await this.searchQuestionsId(qStr)
    let questions = new Array<QuestionRes>()

    for (let idsElement of ids) {
      let result = await questionTable?.querySync(idsElement, false) ?? []
      Logger.info('题目表获取到的数据====>' + result.length)
      if (result.length > 0) {
        questions.push(result[0])
      }
    }

    return questions
  }

  /**
   * 返回相似的题目ID
   * @param q 查询字符串
   * @returns 检索相似的题目的ID
   */
  private async searchQuestionsId(q: string): Promise<List<number>> {
    let mMatchScores = new TreeMap<number, number>()
    if (!StringUtils.isNullOrEmpty(q)) {
      //分词
      let list = SegmentEngine.getInstance().cut(q)
      list.forEach((key: string) => {
        if (this.mStopWords.search(key) != -1) {
          return
        }
        let ids = this.mDataTexts.get(key)
        if (ids != null && ids.length > 0) {
          ids.forEach((id: number) => {
            let score = mMatchScores.get(id) == null ? 0.0 : mMatchScores.get(id)
            score += Math.log10(this.mDataSize / ids.length)
            mMatchScores.set(id, score)
          })
        }
      })
    }

    // TODO 这里需要获取的数量根据情况修改，安卓速度还好，鸿蒙有点慢
    //获取top 100
    let topN = 100
    let topList = new LinkedList<TopItem>()
    mMatchScores.forEach((value: number, key: number): void => {
      if (topList.length === 0) {
        let item = new TopItem()
        item.id = key
        item.score = value
        topList.add(item)
      } else {
        let isAdd = false
        for (let i = 0; i < topList.length; i++) {
          if (value > topList[i].score) {
            let item = new TopItem()
            item.id = key
            item.score = value
            topList.set(i, item)
            isAdd = true
            return
          }
        }
        if (!isAdd && value > SearchEngine.MIN_SCORE) {
          let item = new TopItem()
          item.id = key
          item.score = value
          topList.add(item)
        }
        while (topList.length > topN) {
          topList.removeLast()
        }
      }
    })

    // 处理分数,并且对相同的问题去重
    let resList = new List<TopItem>()
    let qsCache = new TreeSet<string>()
    for (let item of topList) {
      let result = await questionTable?.querySync(item.id, false) ?? [];
      Logger.info('题目表获取到的数据====>' + result.length)
      if (result.length > 0) {
        let qs: QuestionRes = result[0]
        let cacheStr: string = qs.question + " " + (qs.option).join(SearchConstants.SEPARATOR)
        if (qsCache.has(cacheStr)) {
          continue
        }
        qsCache.add(cacheStr)
        let ss = ""
        if (qs != null) {
          ss = qs.question + qs.answer
        }
        let lcsVal = this.lcs(q, ss)
        let score = item.score * lcsVal * 1.0 / ss.length
        let topItem = new TopItem()
        // topItem.id = qs.id
        topItem.score = score
        resList.add(item)
      }
    }

    //将结果按照相似度排序
    let ids = new List<number>()
    resList.sort((o1: TopItem, o2: TopItem) => {
      return o2.score - o1.score < 0 ? -1 : 1
    })

    for (let i = 0; i < (resList.length > 10 ? 10 : resList.length); i++) {
      ids.add(resList.get(i).id)
    }
    return ids
  }


  //计算两个字符串最长公共子序列
  private lcs(s1: string, s2: string): number {
    if (StringUtils.isNullOrEmpty(s1) || StringUtils.isNullOrEmpty(s2)) {
      return 0
    }
    const lenStr1 = s1.length
    const lenStr2 = s2.length
    let r: number[][] = []
    // 初始化数组
    for (let i = 0; i < lenStr1 + 1; i++) {
      let arr = new Array<number>()
      for (let j = 0; j < lenStr2 + 1; j++) {
        arr.push(0)
      }
      r.push(arr)
    }
    for (let i = 0; i < lenStr1; i++) {
      for (let j = 0; j < lenStr2; j++) {
        if ((s1.substring(i, i + 1)) === (s2.substring(j, j + 1))) {
          r[i + 1][j + 1] = r[i][j] + 1
        } else if (r[i + 1][j] > r[i][j + 1]) {
          r[i + 1][j + 1] = r[i + 1][j]
        } else {
          r[i + 1][j + 1] = r[i][j + 1]
        }
      }
    }
    return r[lenStr1][lenStr2]
  }
}

class TopItem {
  id: number = -1
  score: number = 0.0
}