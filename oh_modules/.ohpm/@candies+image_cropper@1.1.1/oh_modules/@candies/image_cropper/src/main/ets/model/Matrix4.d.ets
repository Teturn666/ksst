export declare class Matrix4 {
    private _m4storage;
    get m4storage(): Array<number>;
    static zero(): Matrix4;
    static identity(): Matrix4;
    static rotationY(radians: number): Matrix4;
    static rotationZ(radians: number): Matrix4;
    setIdentity(): void;
    translate(x: number, y?: number, z?: number): void;
    multiply(arg: Matrix4): void;
    setRotationY(radians: number): void;
    setRotationZ(radians: number): void;
    transform(arg: Vector4): Vector4;
    setFrom(arg: Matrix4): void;
    copyInverse(arg: Matrix4): number;
    invert(): number;
}
export declare class Vector4 {
    get x(): number;
    get y(): number;
    get z(): number;
    get w(): number;
    _m4storage: Array<number>;
    constructor(x: number, y: number, z: number, w: number);
}
