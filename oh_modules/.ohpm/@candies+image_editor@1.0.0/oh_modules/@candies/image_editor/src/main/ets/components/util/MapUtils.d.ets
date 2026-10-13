import { common2D } from '@kit.ArkGraphics2D';
import { Offset } from '@kit.ArkUI';
export declare class MapUtils {
    static get<T>(map: Map<string, ESObject>, key: string, defaultValue: T): T;
    static getMap(map: Map<string, ESObject>, key: string): Map<string, ESObject>;
    static getColor(map: Map<string, ESObject>): common2D.Color;
    static getRect(map: Map<string, ESObject>): common2D.Rect;
    static getOffset(map: Map<string, ESObject>): Offset;
}
