/**
 * 预热桶限流，令牌桶的升级版本，除了令牌桶本身的优点，额外解决了令牌桶初始生产速率慢的问题。
 *
 */
export declare class TokenBucket {
    private readonly capacity;
    private readonly rate;
    private tokens;
    private lastRefillTime;
    constructor(r1: number, s1: number);
    /**
     * 处理传入的请求，并返回是否允许通过
     */
    canPass(): boolean;
}
