import { geometry } from './model/Geometry';
export declare function lerpDouble(a: number, b: number, t: number): number;
export declare class NumberUtils {
    static precisionErrorTolerance: number;
    static isZero(value: number): boolean;
    static compare(value1: number, value2: number, precision?: number): number;
    static greaterThan(value1: number, value2: number, precision?: number): boolean;
    static lessThan(value1: number, value2: number, precision?: number): boolean;
    static equalTo(value1: number, value2: number, precision?: number): boolean;
    static greaterThanOrEqualTo(value1: number, value2: number, precision?: number): boolean;
    static lessThanOrEqualTo(value1: number, value2: number, precision?: number): boolean;
    static equalToNullable(value1: number | undefined | null, value2: number | undefined | null, precision?: number): boolean;
    private static degrees2Radians;
    private static radians2Degrees;
    static degrees(radians: number): number;
    static radians(degrees: number): number;
}
export declare class RectUtils {
    static beyond(rect: geometry.Rect, other: geometry.Rect): boolean;
    static topIsSame(rect: geometry.Rect, other: geometry.Rect): boolean;
    static leftIsSame(rect: geometry.Rect, other: geometry.Rect): boolean;
    static rightIsSame(rect: geometry.Rect, other: geometry.Rect): boolean;
    static bottomIsSame(rect: geometry.Rect, other: geometry.Rect): boolean;
    static isSame(rect: geometry.Rect, other: geometry.Rect): boolean;
    static isSameNullable(rect: geometry.Rect | undefined, other: geometry.Rect | undefined): boolean;
    static containsOffset(rect: geometry.Rect, offset: geometry.Offset, include?: boolean): boolean;
    static containsRect(rect: geometry.Rect, other: geometry.Rect): boolean;
}
export declare class OffsetUtils {
    static isSame(offset: geometry.Offset, other: geometry.Offset): boolean;
    static isZero(offset: geometry.Offset): boolean;
}
export declare class UndefinedUtils {
    static isSame(a: ESObject, b: ESObject): boolean;
}
export declare class NullableUtils {
    static isSame(a: ESObject, b: ESObject): boolean;
}
export declare class EdgeInsetsUtils {
    static isSame(edgeInsets: geometry.EdgeInsets, other: geometry.EdgeInsets): boolean;
    static isSameNullable(edgeInsets: geometry.EdgeInsets | undefined, other: geometry.EdgeInsets | undefined): boolean;
}
export declare enum BoxFit {
    fill = 0,
    contain = 1,
    cover = 2,
    fitWidth = 3,
    fitHeight = 4,
    none = 5,
    scaleDown = 6
}
export declare function getDestinationRect(layoutRect: geometry.Rect, inputSize: geometry.Size): geometry.Rect;
export declare function applyBoxFit(fit: BoxFit, inputSize: Size, outputSize: Size): FittedSizes;
export declare class FittedSizes {
    source: Size;
    destination: Size;
    constructor(source: Size, destination: Size);
}
export declare function rgbToHex(r: number, g: number, b: number, opacity?: number): string;
export declare function decimalToHexColor(decimalColor: number, opacity?: number): string;
export declare function hexColorWithOpacity(hexColor: string, opacity?: number): string;
export declare function debounce(fn: () => void, duration: number): () => void;
export declare function clamp(value: number, low: number, high: number): number;
