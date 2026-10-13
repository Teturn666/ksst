import { geometry } from "../model/Geometry";
export declare abstract class Curve {
    abstract transform(t: number): number;
}
interface IntervalParam {
    begin: number;
    end: number;
    curve: Curve;
    beginValue: number;
    endValue: number;
}
export declare class Interval extends Curve {
    constructor(value: IntervalParam);
    begin: number;
    end: number;
    curve: Curve;
    beginValue: number;
    endValue: number;
    transform(t: number): number;
}
export declare class OvershootCurve extends Curve {
    transform(t: number): number;
}
export declare class DecelerateCurve extends Curve {
    transform(t: number): number;
}
export declare class Cubic extends Curve {
    constructor(a: number, b: number, c: number, d: number);
    transform(t: number): number;
    a: number;
    b: number;
    c: number;
    d: number;
    static _cubicErrorBound: number;
    static ease: Cubic;
    _evaluateCubic(a: number, b: number, m: number): number;
    transformInternal(t: number): number;
}
export declare class RectTween {
    transform(t: number): geometry.Rect;
    begin: geometry.Rect;
    end: geometry.Rect;
    constructor(begin: geometry.Rect, end: geometry.Rect);
}
export {};
