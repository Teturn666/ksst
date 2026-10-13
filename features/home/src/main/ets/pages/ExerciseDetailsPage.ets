import { TitleBar } from 'widget/Index';
import { promptAction, router } from '@kit.ArkUI';
import { QuestionRes } from 'db';
import HomeConstants from '../Constants/HomeConstants';

interface DetailParams {
  title: string;
  correctCount: number;
  wrongCount: number;
  timeSpent: string;
  questions: QuestionRes[];
  typepage:number;
}

@Entry({ routeName: "exerciseDetailsPage" })
@Component
struct ExerciseDetailsPage {
  @State title: string = ''; // 题目标题
  @State correctCount: number = 0; // 正确题数
  @State wrongCount: number = 0; // 错误题数
  @State timeSpent: string = '00:00'; // 花费时间
  @State isLoading: boolean = true;
  @State questions: QuestionRes[] = [];
  @State typepage:number = -1;  //模拟考试 1 错题练习 2 收藏练习 3

  aboutToAppear(): void {
    const params = router.getParams() as DetailParams | undefined;
    if (params) {
      this.typepage = params.typepage;
      this.title = params.title || '未知题库';
      this.correctCount = params.correctCount || 0;
      this.wrongCount = params.wrongCount || 0;
      this.timeSpent = params.timeSpent || '00:00';
      this.questions = params.questions || [];
      setTimeout(() => {
        console.log('两秒后执行');
        this.isLoading = false;
      }, 2000);
    } else {
      setTimeout(() => {
        console.log('两秒后执行');
        this.isLoading = false;
      }, 2000);
      promptAction.showToast({ message: '未接收到练习数据', duration: 2000 });
      router.back();
    }
  }

  build() {
    if (this.isLoading) {
      Column() {
        Image($r('app.media.ic_lian'))
          .height(24)
          .margin({ top: 58 });
        Image($r('app.media.ic_ok'))
          .width(155)
          .height(155)
          .margin({ top: 68 });
        Text("即将进入练习详情...")
          .fontColor(Color.Grey)
          .fontSize(16)
          .margin({top:28})
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)
      .backgroundColor(Color.White);
    } else {
      Column() {
        // 头部
        TitleBar({
          title: "练习详情",
          backClick: () => {
            router.back();
          }
        })
          .width('100%');

        // 题目信息
        Row() {
          Image($r('app.media.ic_question_bank'))
            .width(18)
            .height(18);
          Text('  题目: ' + this.title)
            .fontColor('#060606')
            .fontSize(14);
        }
        .width('90%')
        .margin({ top: 18, left: 28 });

        // 统计信息
        Column() {
          Row() {
            Text('您答对了')
              .fontColor('#404040')
              .fontSize(14);
            Text(this.correctCount.toString())
              .fontColor('#F75A23')
              .fontSize(14);
            Text('道题目，答错')
              .fontColor('#404040')
              .fontSize(14);
            Text(this.wrongCount.toString())
              .fontColor('#F75A23')
              .fontSize(14);
            Text('道题。')
              .fontColor('#404040')
              .fontSize(14);
          }
          .margin({ top: 8 });

          Row() {
            Text('共花费时间：')
              .fontColor('#404040')
              .fontSize(14);
            Text(this.timeSpent)
              .fontColor('#F75A23')
              .fontSize(14);
          }
          .margin({ top: 8 });
        }
        .padding({ left: 8, top: 8 })
        .margin({ top: 10 })
        .alignItems(HorizontalAlign.Start)
        .width('90%')
        .height(70)
        .backgroundColor('#f3f1f1')
        .borderRadius(8);

        // 内容区域（支持滚动）
        Scroll() {
          Column() {
            ForEach(this.questions, (item: QuestionRes, index: number) => {
              Column() {
                Text(item.question + item.question) // 重复以模拟长文本
                  .fontColor('#333333')
                  .fontSize(12)
                  .margin({ top: 8 });

                Column() {
                  ForEach(item.option, (option: string, idx: number) => {
                    Text(option)
                      .fontColor('#333333')
                      .fontSize(12)
                      .margin({ top: idx === 0 ? 15 : 0 });
                  });
                }
                .width('100%')
                .alignItems(HorizontalAlign.Start);

                Row() {
                  Row() {
                    Text('正确答案：')
                      .fontColor('#333333')
                      .fontSize(14);
                    Text(item.answer)
                      .fontColor(Color.Blue)
                      .fontSize(14);
                  }
                  .margin({ right: 20 });
                  Row() {
                    Text('您的答案：')
                      .fontColor('#333333')
                      .fontSize(14);
                    Text(item.wrongAnswer || '未答')
                      .fontColor(Color.Red)
                      .fontSize(14);
                  }
                }
                .backgroundColor(
                  item.wrongAnswer && item.wrongAnswer !== '未答'
                    ? (item.answer.length > 1 && item.wrongAnswer.includes(',')
                    ? (item.wrongAnswer.split(',').sort().join(',') === item.answer.split(',').sort().join(',')
                      ? '#ebf4e6'
                      : '#f7e9e9')
                    : (item.wrongAnswer === item.answer
                      ? '#ebf4e6'
                      : '#f7e9e9'))
                    : '#f7e9e9'
                )
                .justifyContent(FlexAlign.SpaceAround)
                .margin({ top: 8 })
                .borderRadius(8)
                .width('100%')
                .height(29);
              }
              .margin({ bottom: 16 });
            });
          }
          .alignItems(HorizontalAlign.Start)
          .padding({ left: 18, top: 18, right: 18 })
          .width('100%');
        }
        .height('65%')
        .backgroundColor(Color.White);

        // 底部按钮
        Blank()
          .height(20);
        Row() {
          Image($r('app.media.ic_keep_practicing'))
            .width(122)
            .height(40)
            .onClick(() => {
              router.pushNamedRoute({
                name: HomeConstants.ROUTER_EXERCISE_COMMON_LIST,
                params: {
                  practiceMode: this.typepage,
                  qid: this.questions[0]?.qId || -1,
                }
              });
            });
          Image($r('app.media.ic_quit_practice'))
            .width(122)
            .height(40)
            .onClick(() => {
              let index = Number(router.getLength()) - 2
              router.back(index,router.RouterMode.Single)
            });
        }
        .justifyContent(FlexAlign.SpaceEvenly)
        .width('100%')
        .height(80)
        .backgroundColor('#ffffff');
      }
      .height('100%')
      .width('100%')
      .backgroundColor(Color.White);
    }
  }
}