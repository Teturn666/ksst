export declare namespace geometry {
    abstract class OffsetBase {
        _dx: number;
        _dy: number;
        constructor(dx: number, dy: number);
        get isInfinite(): boolean;
        get isFinite(): boolean;
        lessThan(other: OffsetBase): boolean;
        lessThanOrEqual(other: OffsetBase): boolean;
        greaterThan(other: OffsetBase): boolean;
        greaterThanOrEqual(other: OffsetBase): boolean;
        equals(other: ESObject): boolean;
        get hashCode(): number;
        toString(): string;
    }
    export class Offset extends OffsetBase {
        static fromDirection(direction: number, distance?: number): Offset;
        get dx(): number;
        get dy(): number;
        get distance(): number;
        get distanceSquared(): number;
        get direction(): number;
        static readonly zero: Offset;
        static readonly infinite: Offset;
        scale(scaleX: number, scaleY: number): Offset;
        translate(translateX: number, translateY: number): Offset;
        negate(): Offset;
        subtract(other: Offset): Offset;
        add(other: Offset): Offset;
        multiply(operand: number): Offset;
        divide(operand: number): Offset;
        modulo(operand: number): Offset;
        static lerp(a: Offset | null, b: Offset | null, t: number): Offset | null;
        equals(other: ESObject): boolean;
        get hashCode(): number;
        toString(): string;
    }
    export class Size extends OffsetBase {
        constructor(width: number, height: number);
        static square(dimension: number): Size;
        static fromWidth(width: number): Size;
        static fromHeight(height: number): Size;
        static fromRadius(radius: number): Size;
        get width(): number;
        get height(): number;
        get aspectRatio(): number;
        get isEmpty(): boolean;
        get shortestSide(): number;
        get longestSide(): number;
        subtract(other: OffsetBase): OffsetBase;
        add(other: Offset): Size;
        multiply(scalar: number): Size;
        divide(scalar: number): Size;
        contains(offset: Offset): boolean;
        equals(other: ESObject): boolean;
        toString(): string;
        static readonly zero: Size;
        static readonly infinite: Size;
    }
    export class Rect {
        constructor(left: number, top: number, right: number, bottom: number);
        static fromLTRB(left: number, top: number, right: number, bottom: number): Rect;
        static fromLTWH(left: number, top: number, width: number, height: number): Rect;
        static fromCircle(center: Offset, radius: number): Rect;
        static fromCenter(center: Offset, width: number, height: number): Rect;
        static fromPoints(a: Offset, b: Offset): Rect;
        static fromOffsetSize(offse: Offset, size: Size): Rect;
        left: number;
        top: number;
        right: number;
        bottom: number;
        get width(): number;
        get height(): number;
        get size(): Size;
        get hasNaN(): boolean;
        static zero: Rect;
        static largest: Rect;
        get isInfinite(): boolean;
        get isFinite(): boolean;
        get isEmpty(): boolean;
        shift(offset: Offset): Rect;
        translate(translateX: number, translateY: number): Rect;
        inflate(delta: number): Rect;
        deflate(delta: number): Rect;
        intersect(other: Rect): Rect;
        expandToInclude(other: Rect): Rect;
        overlaps(other: Rect): boolean;
        get shortestSide(): number;
        get longestSide(): number;
        get topLeft(): Offset;
        get topCenter(): Offset;
        get topRight(): Offset;
        get centerLeft(): Offset;
        get center(): Offset;
        get centerRight(): Offset;
        get bottomLeft(): Offset;
        get bottomCenter(): Offset;
        get bottomRight(): Offset;
        contains(offset: Offset): boolean;
        static lerp(a: Rect | null, b: Rect | null, t: number): Rect | null;
        equals(other: ESObject): boolean;
        toString(): string;
    }
    export class EdgeInsets {
        readonly left: number;
        readonly top: number;
        readonly right: number;
        readonly bottom: number;
        constructor(left: number, top: number, right: number, bottom: number);
        static fromLTRB(left: number, top: number, right: number, bottom: number): EdgeInsets;
        static all(value: number): EdgeInsets;
        static only(left?: number, top?: number, right?: number, bottom?: number): EdgeInsets;
        static symmetric(vertical?: number, horizontal?: number): EdgeInsets;
        inflateRect(rect: Rect): EdgeInsets;
        deflateRect(rect: Rect): Rect;
        copyWith(left?: number, top?: number, right?: number, bottom?: number): EdgeInsets;
    }
    export {};
}
