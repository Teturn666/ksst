@Observed
export default class CheckDataRes {
  days: number = 0;
  point: number = 0;
}

@Observed
export  class PointEventRes {
  id: number = 0;
  userId: number = 0;
  behavior: string = ''
  pointUpdate: number = 0
  pointBefore: number = 0
  pointAfter: number = 0
  time: string = ''
}

@Observed
export class PointsDetail {
  behavior: string = ''
  points: string = ''
  time: string =''

  constructor(behavior:string, points:string, time:string) {
    this.behavior = behavior
    this.points = points
    this.time = time
  }
}




@Observed
export class showSingle {
  days: string = '';
  point: string = '';
  type: number = 0; //  1，已领取。 2. 点击领取。 3. 未领取
  constructor(days: number, point: number, type: number) {
    this.days = String(days)
    this.point = String(point)
    this.type = type
  }
}