import { router } from '@kit.ArkUI'
import promptAction from '@ohos.promptAction';
import { QuestionRes, questionCollectionTable, questionTable,questionWrongTable } from 'db';
import HomeConstants from '../Constants/HomeConstants';
import { BankListRes } from '../model/BankListRes';
import { HomeModel } from '../model/HomeModel';

import('./ExerciseCommonPage')

interface questionSelections {
  selectedOption: string;
  selectedOptions: string[];
  hasSubmitted: boolean;
}

@Entry({ routeName: 'exercisePage' })
@Component
struct ExercisePage {
  @State qid: number = -1
  @State homeModel: HomeModel = HomeModel.getInstance()
  @State questions: QuestionRes[] = [];
  @State selectedIndex: number = 0; // 0 for 答题, 1 for 背题
  @State currentQuestionIndex: number = 0; // 当前问题索引
  @State currentProgress: number = 1; // 目前进度
  @State isStarred: boolean = false; //
  @State questionType: string = 'multiple';
  @State hasSubmitted: boolean = false;
  @State selectedOption: string = ''; // 单选
  @State selectedOptions: string[] = []; // 多选
  @State questionSelections: Record<number, questionSelections> = {}; // 记录每题选择
  @State totalProgress: number = this.questions.length;
  @State favoriteStatus: Record<number, boolean> = {}; // 按 questionID 存储收藏状态

  // 在 ExercisePage 组件内添加以下方法
  private async saveToWrongTable(question: QuestionRes, wrongAnswer: string) {
    try {
      let questionDb = new QuestionRes();
      questionDb.qId = question.qId;
      questionDb.question = question.question;
      questionDb.answer = question.answer;
      questionDb.option = question.option;
      questionDb.wrongAnswer = wrongAnswer;
      questionDb.questionID = question.questionID;
      await questionWrongTable.insertDataAwait(questionDb);
      this.homeModel.getWrongQuestionList(question.qId)

    } catch (err) {
      console.error('插入错题表失败:', err);
      promptAction.showToast({ message: '保存错题失败', duration: 1500 });
    }
  }

  // 修改 handleOptionClick 方法
  private async handleOptionClick(optionLabel: string) {
    if (this.selectedIndex === 0 && !this.hasSubmitted) {
      const currentQuestion = this.questions[this.currentQuestionIndex];
      if (this.isMultipleChoice()) {
        // 多选：切换选项状态
        if (this.selectedOptions.includes(optionLabel)) {
          this.selectedOptions = this.selectedOptions.filter(opt => opt !== optionLabel);
        } else {
          this.selectedOptions = [...this.selectedOptions, optionLabel];
          const correctAnswers = currentQuestion.answer.split('');

          // 检查是否选择了错误选项
          if (!correctAnswers.includes(optionLabel)) {
            this.hasSubmitted = true;
            promptAction.showToast({ message: '回答错误', duration: 1500 });
            // 插入错题表
            await this.saveToWrongTable(currentQuestion, optionLabel);
            this.saveQuestionState(); // 记录错误提交状态
          } else {
            // 检查是否选中了全部正确答案
            const allCorrectSelected = correctAnswers.every(ans => this.selectedOptions.includes(ans)) &&
            this.selectedOptions.every(opt => correctAnswers.includes(opt));
            if (allCorrectSelected) {
              this.hasSubmitted = true;
              promptAction.showToast({ message: '回答正确', duration: 1500 });
              this.saveQuestionState(); // 记录正确提交状态
            }
          }
        }
        this.saveQuestionState(); // 记录多选过程中的选择
      } else {
        // 单选：设置选项并提交
        this.selectedOption = optionLabel;
        this.hasSubmitted = true;

        const isCorrect = optionLabel === currentQuestion.answer;
        promptAction.showToast({
          message: isCorrect ? '回答正确' : '回答错误',
          duration: 1500
        });
        if (!isCorrect) {
          // 插入错题表
          await this.saveToWrongTable(currentQuestion, optionLabel);
        }
        this.saveQuestionState(); // 记录单选提交状态
      }
    }
  }

  private isMultipleChoice(): boolean {
    const answer = this.questions[this.currentQuestionIndex].answer;
    return answer.length > 1 && /^[A-D]+$/.test(answer);
  }

  private resetQuestionState() {
    this.selectedOption = '';
    this.selectedOptions = [];
    this.hasSubmitted = false;
  }

  private async saveQuestionState() {
    // 保存当前题目的选择状态到内存
    this.questionSelections[this.currentQuestionIndex] = {
      selectedOption: this.selectedOption,
      selectedOptions: [...this.selectedOptions],
      hasSubmitted: this.hasSubmitted
    };
    console.log('Saved state for question', this.currentQuestionIndex,
      this.questionSelections[this.currentQuestionIndex]);
  }

  private restoreQuestionState() {
    const state = this.questionSelections[this.currentQuestionIndex];
    if (state) {
      this.selectedOption = state.selectedOption;
      this.selectedOptions = [...state.selectedOptions];
      this.hasSubmitted = state.hasSubmitted;
      console.log('Restored state for question', this.currentQuestionIndex, state);
    } else {
      this.resetQuestionState();
    }
    this.checkFavoriteStatus(); // 恢复当前题目的收藏状态
  }

  private async checkFavoriteStatus() {
    const currentQuestion = this.questions[this.currentQuestionIndex];
    const questionID = currentQuestion.questionID;
    try {
      const existedList = await this.homeModel.getCollectionQuestionList(currentQuestion.qId);
      this.favoriteStatus[questionID] = existedList.some(item => item.questionID === questionID);
    } catch (err) {
      console.error('检查收藏状态失败:', err);
      this.favoriteStatus[questionID] = false;
    }
  }

  private async toggleFavorite() {
    const currentQuestion: QuestionRes = this.questions[this.currentQuestionIndex];
    const questionID = currentQuestion.questionID;

    try {
      const existedList = await this.homeModel.getCollectionQuestionList(currentQuestion.qId);
      const isQuestionInCollection = existedList.some(item => item.questionID === questionID);

      if (isQuestionInCollection) {
        await questionCollectionTable.deleteData(currentQuestion, () => {
          this.favoriteStatus[questionID] = false;
          promptAction.showToast({ message: '已取消收藏', duration: 1500 });
        });
      } else {
        let questionDb = new QuestionRes();
        questionDb.qId = currentQuestion.qId;
        questionDb.question = currentQuestion.question;
        questionDb.answer = currentQuestion.answer;
        questionDb.option = currentQuestion.option;
        questionDb.wrongAnswer = "B"; // 如果需要，动态设置
        questionDb.questionID = questionID;

        await questionCollectionTable.insertDataAwait(questionDb);
        this.favoriteStatus[questionID] = true;
        promptAction.showToast({ message: '收藏成功', duration: 1500 });
      }
    } catch (err) {
      console.error('收藏操作失败:', err);
      promptAction.showToast({ message: '收藏操作失败', duration: 1500 });
    }
  }

  // 题目列表获取
  async getBankQuestionList(qid: number): Promise<void> {
    try {
      const list = await this.homeModel.getBankQuestionList(qid);
      if (list.length > 0) {
        this.questions = list;
        this.totalProgress = list.length;
        this.currentQuestionIndex = 0;
        this.currentProgress = 1;
        this.questionSelections = {};
        this.favoriteStatus = {};
        this.resetQuestionState();
        // 批量检查收藏状态
        const existedList = await this.homeModel.getCollectionQuestionList(qid);
        list.forEach((question) => {
          this.favoriteStatus[question.questionID] = existedList.some(item => item.questionID === question.questionID);
        });
      } else {
        promptAction.showToast({ message: '暂无题目数据', duration: 2000 });
      }
    } catch (err) {
      console.error('获取题目失败:', err);
      promptAction.showToast({ message: '题目加载失败', duration: 2000 });
    }
  }

  private getOptionLabel(index: number): string {
    return String.fromCharCode(65 + index);
  }

  private resetProgress() {
    promptAction.showDialog({
      title: '提示',
      message: '重置进度后将从第一题重新开始练习',
      buttons: [
        { text: '取消', color: '#666666' },
        { text: '确定', color: '#d2a129' },
      ],
    }).then((data) => {
      if (data.index === 1) {
        this.currentProgress = 1;
        this.currentQuestionIndex = 0;
        this.questionSelections = {}; // 清空选择记录
        this.resetQuestionState();
        promptAction.showToast({ message: '进度已重置', duration: 1500 });
      }
    });
  }

  private goToPreviousQuestion() {
    if (this.currentQuestionIndex > 0) {
      this.currentQuestionIndex--;
      this.currentProgress = this.currentQuestionIndex + 1;
      this.restoreQuestionState(); // 恢复上一题的选择
      promptAction.showToast({ message: '已切换到上一题', duration: 1000 });
    } else {
      promptAction.showToast({ message: '已经是第一题', duration: 1500 });
    }
  }

  private goToNextQuestion() {
    if (this.currentQuestionIndex < this.questions.length - 1) {
      this.currentQuestionIndex++;
      this.currentProgress = this.currentQuestionIndex + 1;
      this.restoreQuestionState(); // 恢复下一题的选择
      promptAction.showToast({ message: '已切换到下一题', duration: 1000 });
    } else {
      promptAction.showToast({ message: '已经是最后一题', duration: 1500 });
    }
  }

  private getQuestionTypeImage(): Resource {
    const question = this.questions[this.currentQuestionIndex];
    const options = question.option;
    const answer = question.answer;

    const isTrueFalse = options.length === 2 && options.includes('正确') && options.includes('错误');
    const isMultiple = answer.length > 1 && /^[A-D]+$/.test(answer);

    if (isMultiple) {
      return $r('app.media.ic_mu');
    } else if (isTrueFalse) {
      return $r('app.media.ic_es');
    } else {
      return $r('app.media.ic_ch');
    }
  }


  build() {
    if (this.questions.length > 0)
    Column() {
      // 头部
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
        Image($r('app.media.ic_back'))
          .objectFit(ImageFit.Contain)
          .size({ width: $r('app.float.float_48vp'), height: $r('app.float.float_48vp') })
          .margin({ left: 15, right: 15 })
          .align(Alignment.TopStart)
          .onClick(() => router.back())
        Button($r('app.media.ic_back'))
          .width(50)
          .height(50)
          .backgroundColor('#FFFFFF')
          .borderRadius(6)
          .onClick(() => {
            router.back();
          })
          .margin({ right: 20 })
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Button() {
            Row() {
              Button('答题')
                .fontColor(this.selectedIndex == 0 ? '#FFFFFF' : '#d2a129')
                .fontSize(12)
                .border({ width: 1, color: '#d2a129' })
                .width(60)
                .height(28)
                .backgroundColor(this.selectedIndex === 0 ? '#d2a129' : '#FFFFFF')
                .borderRadius(6)
                .padding({ left: 12, right: 12 })
                .onClick(() => {
                  this.selectedIndex = 0;
                  promptAction.showToast({ message: '切换到答题' });
                })
              Button('背题')
                .fontColor(this.selectedIndex == 1 ? '#FFFFFF' : '#d2a129')
                .fontSize(12)
                .border({ width: 1, color: '#d2a129' })
                .width(60)
                .height(28)
                .backgroundColor(this.selectedIndex === 1 ? '#d2a129' : '#FFFFFF')
                .borderRadius(6)
                .padding({ left: 12, right: 12 })
                .onClick(() => {
                  this.selectedIndex = 1;
                  promptAction.showToast({ message: '切换到背题' });
                })
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
          }
          .backgroundColor('#d2a129')
          Blank()
          Button('模拟考试')
            .width(70)
            .height(28)
            .backgroundColor('#d2a129')
            .borderRadius(6)
            .padding({ left: 12, right: 12 })
            .margin({ right: 12 })
            .onClick(() => {
              router.pushNamedRoute({
                name: HomeConstants.ROUTER_EXERCISE_COMMON_LIST,
                params:{
                  practiceMode:1,
                  qid:this.qid
                }
              }, router.RouterMode.Single)
            })
        }
      }

      // 进度条部分
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Progress({
          type: ProgressType.Linear,
          value: this.currentProgress,
          total: this.totalProgress,
        })
          .color(Color.Orange)
          .width('60%')
          .height(16)
          .backgroundColor('#dadada')
          .style({ strokeWidth: 15 })
        Text(`${this.currentProgress}/${this.totalProgress}`)
          .fontSize(12)
          .fontColor(Color.Black)
        Text('重置进度')
          .fontSize(12)
          .onClick(() => {
            this.resetProgress()
          })
      }
      .backgroundColor('#f5f3f4')
      .borderRadius(8)
      .width('90%')
      .height(50)
      .margin({ top: 10 })
      .padding(10)

      // 内容部分
      Row() {
        Image(this.getQuestionTypeImage())
          .height(24)
          .objectFit(ImageFit.Cover)
        Blank()
        Image(this.favoriteStatus[this.questions[this.currentQuestionIndex].questionID] ? $r('app.media.stared') : $r('app.media.star'))
          .width(18)
          .height(18)
          .onClick(() => {
            this.toggleFavorite();
          })
          .margin({ right: 5 })
        Text(this.favoriteStatus[this.questions[this.currentQuestionIndex].questionID] ? "已收藏" : "收藏")
          .fontSize(12)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(10)
      .backgroundColor(Color.White)
      .borderRadius(8)
      .margin({ top: 20 })
      .width('90%')

      // 问题描述
      Text(this.questions[this.currentQuestionIndex].question)
        .fontSize(16)
        .padding({ left: 10, right: 10, top: 10 })
        .textAlign(TextAlign.Start)
        .width('90%')

      // 选项列表
      ForEach(this.questions[this.currentQuestionIndex].option, (item: string, idx: number) => {
        Row() {
          Text(this.getOptionLabel(idx))
            .width(30)
            .height(30)
            .textAlign(TextAlign.Center)
            .fontSize(16)
            .fontColor('#000000')
            .borderRadius(15)
            .backgroundColor(
              this.selectedIndex === 1
                ? (this.questions[this.currentQuestionIndex].answer.includes(this.getOptionLabel(idx)) ? '#DFF5E3' :
                '#F2F2F2')
                : (this.hasSubmitted
                ? (this.questions[this.currentQuestionIndex].answer.includes(this.getOptionLabel(idx))
                  ? '#DFF5E3'
                  : (this.isMultipleChoice()
                    ? (this.selectedOptions.includes(this.getOptionLabel(idx)) ? '#FDECEC' : '#F2F2F2')
                    : (this.selectedOption === this.getOptionLabel(idx) ? '#FDECEC' : '#F2F2F2')))
                : (this.isMultipleChoice()
                  ? (this.selectedOptions.includes(this.getOptionLabel(idx)) ? '#B3E5FC' : '#F2F2F2')
                  : (this.selectedOption === this.getOptionLabel(idx) ? '#E0E0E0' : '#F2F2F2')))
            )
            .margin({ right: 10 })
          Text(item)
            .fontSize(16)
            .padding(10)
            .width('80%')
            .borderRadius(8)
            .backgroundColor(
              this.selectedIndex === 1
                ? (this.questions[this.currentQuestionIndex].answer.includes(this.getOptionLabel(idx)) ? '#DFF5E3' :
                '#F2F2F2')
                : (this.hasSubmitted
                ? (this.questions[this.currentQuestionIndex].answer.includes(this.getOptionLabel(idx))
                  ? '#DFF5E3'
                  : (this.isMultipleChoice()
                    ? (this.selectedOptions.includes(this.getOptionLabel(idx)) ? '#FDECEC' : '#F2F2F2')
                    : (this.selectedOption === this.getOptionLabel(idx) ? '#FDECEC' : '#F2F2F2')))
                : (this.isMultipleChoice()
                  ? (this.selectedOptions.includes(this.getOptionLabel(idx)) ? '#B3E5FC' : '#F2F2F2')
                  : (this.selectedOption === this.getOptionLabel(idx) ? '#E0E0E0' : '#F2F2F2')))
            )
        }
        .onClick(() => this.handleOptionClick(this.getOptionLabel(idx)))
        .margin({ top: 12, left: 16, right: 16 })
      })

      if ((this.selectedIndex === 0 && this.hasSubmitted) || this.selectedIndex === 1) {
        Row() {
          Button() {
            Text('上一题')
              .fontSize(16)
              .fontColor('#F2B771')
          }
          .width(100)
          .height(30)
          .backgroundColor(Color.White)
          .borderRadius(20)
          .border({ width: 1, color: '#F2B771' })
          .onClick(() => this.goToPreviousQuestion())

          Button() {
            Text('下一题')
              .fontSize(16)
              .fontColor('#F2B771')
          }
          .backgroundColor(Color.White)
          .width(100)
          .height(30)
          .borderRadius(20)
          .border({ width: 1, color: '#F2B771' })
          .onClick(() => this.goToNextQuestion())
        }
        .justifyContent(FlexAlign.SpaceAround)
        .alignItems(VerticalAlign.Center)
        .padding(10)
        .width('80%')
        .margin({ top: 18 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>;
    if (params.qid) {
      this.qid = parseInt(params.qid, 10);
    }
    console.log('Received qid =', this.qid);
    if (this.qid > 0) {
      this.getBankQuestionList(this.qid).then(() => {
        this.checkFavoriteStatus(); // 初始化第一题的收藏状态
      });
    }
  }


}


// private questions: QuestionRes[] = [
//   {"qId":1735007905,"question":"在道路等开阔地带开展训练时，应做好（）。","answer":"A","option":["安全警戒","后勤保障","着装","准备活动"],"wrongAnswer":""},
//   {"qId":1735007905,"question":"使用绳索开展高空救援时，绳索应避开（）等高温、尖锐部位。","answer":"AB","option":["墙角","烟火","梁、柱","管线井"],"wrongAnswer":""},
//   {"qId":1735007905,"question":"总队、支队安全助理对灭火救援现场安全员实行统一管理。","answer":"A","option":["正确","错误"],"wrongAnswer":""}
// ];