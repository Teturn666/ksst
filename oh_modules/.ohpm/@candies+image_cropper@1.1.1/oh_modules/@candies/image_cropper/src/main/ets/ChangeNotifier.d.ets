type VoidCallback = () => void;
export declare class ChangeNotifier {
    private _count;
    private static _emptyListeners;
    private _listeners;
    private _notificationCallStackDepth;
    private _reentrantlyRemovedListeners;
    private _debugDisposed;
    private static debugAssertNotDisposed;
    protected get hasListeners(): boolean;
    addListener(listener: VoidCallback): void;
    removeListener(listener: VoidCallback): void;
    private _removeAt;
    dispose(): void;
    notifyListeners(): void;
}
export {};
