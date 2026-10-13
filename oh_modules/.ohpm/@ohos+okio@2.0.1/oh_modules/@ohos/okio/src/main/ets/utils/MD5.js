/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { util } from './Utilities.js';
import Log from '../log.js';

export function Md5() {
    md5CompanionGetInstance();
    var messageLength,
        unprocessed0,
        unprocessedLimit0,
        words0,
        h0,
        h1,
        h2,
        h3;
    this.messageLength = util.Long.ZERO;
    this.unprocessed0 = new Int8Array(64);
    this.unprocessedLimit0 = 0;
    this.words0 = new Int32Array(16);
    this.h0 = 1732584193;
    this.h1 = -271733879;
    this.h2 = -1732584194;
    this.h3 = 271733878;
    Log.showInfo("Md5 constructor...")

}
Md5.prototype.update = function (input, offset, byteCount) {
    Log.showInfo("Md5 update started...")
    this.messageLength = this.messageLength.add(util.Long.fromInt(byteCount));
    var pos = offset;
    var limit = pos + byteCount | 0;
    var unprocessed = this.unprocessed0;
    var unprocessedLimit = this.unprocessedLimit0;
    if (unprocessedLimit > 0) {
        if ((unprocessedLimit + byteCount | 0) < 64) {
            this.arrayCopy(input, unprocessed, unprocessedLimit, pos, limit);
            this.unprocessedLimit0 = unprocessedLimit + byteCount | 0;
            Log.showInfo("Md5 update Not enough bytes for a chunk. returns");
            return;
        }
        Log.showInfo("Md5 Process a chunk combining leftover bytes and the input.");
        var consumeByteCount = 64 - unprocessedLimit | 0;
        this.arrayCopy(input, unprocessed, unprocessedLimit, pos, pos + consumeByteCount | 0);
        this.processChunk(unprocessed, 0);
        this.unprocessedLimit0 = 0;
        pos = pos + consumeByteCount | 0;
        Log.showInfo("Md5 Process a chunk current position:" + pos);
    }
    while (pos < limit) {
        var nextPos = pos + 64 | 0;
        if (nextPos > limit) {
            Log.showInfo("Md5 -- update loop Not enough bytes for a chunk. returns");
            this.arrayCopy(input, unprocessed, 0, pos, limit);
            this.unprocessedLimit0 = limit - pos | 0;
            return;
        }
        this.processChunk(input, pos);
        pos = nextPos;
    }
    Log.showInfo("update completed...");
}
Md5.prototype.processChunk = function (input, pos) {
    Log.showInfo("Md5  processChunk");
    var tmp$, tmp0, tmp1, tmp2;
    var words = this.words0;
    var pos0 = pos;
    for (var w = 0; w < 16; w++) {
        words[w] = input[tmp$ = pos0, pos0 = tmp$ + 1 | 0, tmp$] & 255 |
        (input[tmp0 = pos0, pos0 = tmp0 + 1 | 0, tmp0] & 255) << 8 |
        (input[tmp1 = pos0, pos0 = tmp1 + 1 | 0, tmp1] & 255) << 16 |
        (input[tmp2 = pos0, pos0 = tmp2 + 1 | 0, tmp2] & 255) << 24;
    }
    this.hash(words);
    Log.showInfo("Md5  processChunk completed");
};
Md5.prototype.hash = function (words) {
    Log.showInfo("Md5  hash started");
    var localK = md5CompanionGetInstance().k0;
    var localS = md5CompanionGetInstance().s0;
    var a = this.h0;
    var b = this.h1;
    var c = this.h2;
    var d = this.h3;
    for (var i = 0; i < 16; i++) {
        var g = i;
        var f = (b & c | ~b & d) + a + localK[i] + words[g] | 0;
        a = d;
        d = c;
        c = b;
        var tmp$ = b;
        var bitCount = localS[i];
        b = tmp$ + (f << bitCount | f >>> 32 - bitCount) | 0;
    }
    for (var i0 = 16; i0 < 32; i0++) {
        var g0 = ((5 * i0 | 0) + 1 | 0) % 16;
        var f0 = (d & b | ~d & c) + a + localK[i0] + words[g0] | 0;
        a = d;
        d = c;
        c = b;
        var tmp0 = b;
        var bitCount0 = localS[i0];
        b = tmp0 + (f0 << bitCount0 | f0 >>> 32 - bitCount0) | 0;
    }
    for (var i1 = 32; i1 < 48; i1++) {
        var g1 = ((3 * i1 | 0) + 5 | 0) % 16;
        var f1 = (b ^ c ^ d) + a + localK[i1] + words[g1] | 0;
        a = d;
        d = c;
        c = b;
        var tmp1 = b;
        var bitCount1 = localS[i1];
        b = tmp1 + (f1 << bitCount1 | f1 >>> 32 - bitCount1) | 0;
    }
    for (var i2 = 48; i2 < 64; i2++) {
        var g2 = (7 * i2 | 0) % 16;
        var f2 = (c ^ (b | ~d)) + a + localK[i2] + words[g2] | 0;
        a = d;
        d = c;
        c = b;
        var tmp2 = b;
        var bitCount2 = localS[i2];
        b = tmp2 + (f2 << bitCount2 | f2 >>> 32 - bitCount2) | 0;
    }
    this.h0 = this.h0 + a | 0;
    this.h1 = this.h1 + b | 0;
    this.h2 = this.h2 + c | 0;
    this.h3 = this.h3 + d | 0;
    Log.showInfo("Md5  hash completed");
};
Md5.prototype.digest = function () {
    Log.showInfo("Md5  digest started");
    var tmp$;
    var messageLengthBits = this.messageLength.multiply(util.Long.fromInt(8));
    this.unprocessed0[tmp$ = this.unprocessedLimit0, this.unprocessedLimit0 = tmp$ + 1 | 0, tmp$] = this.toByte(128);
    if (this.unprocessedLimit0 > 56) {
        this.fill(this.unprocessed0, 0, this.unprocessedLimit0, 64);
        this.processChunk(this.unprocessed0, 0);
        this.fill(this.unprocessed0, 0, 0, this.unprocessedLimit0);
    } else {
        this.fill(this.unprocessed0, 0, this.unprocessedLimit0, 56);
    }
    this.unprocessed0[56] = this.toByte(messageLengthBits.toInt());
    this.unprocessed0[57] = this.toByte(messageLengthBits.shiftRightUnsigned(8).toInt());
    this.unprocessed0[58] = this.toByte(messageLengthBits.shiftRightUnsigned(16).toInt());
    this.unprocessed0[59] = this.toByte(messageLengthBits.shiftRightUnsigned(24).toInt());
    this.unprocessed0[60] = this.toByte(messageLengthBits.shiftRightUnsigned(32).toInt());
    this.unprocessed0[61] = this.toByte(messageLengthBits.shiftRightUnsigned(40).toInt());
    this.unprocessed0[62] = this.toByte(messageLengthBits.shiftRightUnsigned(48).toInt());
    this.unprocessed0[63] = this.toByte(messageLengthBits.shiftRightUnsigned(56).toInt());
    this.processChunk(this.unprocessed0, 0);
    var a = this.h0;
    var b = this.h1;
    var c = this.h2;
    var d = this.h3;
    Log.showInfo("Md5  digest completed");
    return new Int8Array([this.toByte(a), this.toByte(a >> 8),
    this.toByte(a >> 16), this.toByte(a >> 24), this.toByte(b),
    this.toByte(b >> 8), this.toByte(b >> 16), this.toByte(b >> 24),
    this.toByte(c), this.toByte(c >> 8), this.toByte(c >> 16), this.toByte(c >> 24),
    this.toByte(d), this.toByte(d >> 8), this.toByte(d >> 16), this.toByte(d >> 24)]);
};

function Md5$Companion() {
    md5CompanionInstance = this;
    this.s0 = new Int32Array([7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 5, 9, 14,
        20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 4, 11, 16, 23, 4, 11, 16,
        23, 4, 11, 16, 23, 4, 11, 16, 23, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10,
        15, 21, 6, 10, 15, 21]);
    this.k0 = new Int32Array([-680876936, -389564586, 606105819, -1044525330, -176418897, 1200080426,
        -1473231341, -45705983, 1770035416, -1958414417, -42063, -1990404162,
        1804603682, -40341101, -1502002290, 1236535329, -165796510, -1069501632,
        643717713, -373897302, -701558691, 38016083, -660478335, -405537848, 568446438,
        -1019803690, -187363961, 1163531501, -1444681467, -51403784, 1735328473, -1926607734,
        -378558, -2022574463, 1839030562, -35309556, -1530992060, 1272893353, -155497632,
        -1094730640, 681279174, -358537222, -722521979, 76029189, -640364487, -421815835,
        530742520, -995338651, -198630844, 1126891415, -1416354905, -57434055, 1700485571,
        -1894986606, -1051523, -2054922799, 1873313359, -30611744, -1560198380, 1309151649,
        -145523070, -1120210379, 718787259, -343485551]);
}

var md5CompanionInstance = null;

function md5CompanionGetInstance() {
    if (md5CompanionInstance === null) {
        new Md5$Companion();
    }
    return md5CompanionInstance;
}

Md5.prototype.isView = function (a) {
    return a != null && Object.getPrototypeOf(a) != null && Object.getPrototypeOf(a) === Int8Array.prototype;
};
Md5.prototype.arrayCopy = function (source, destination, destinationOffset, startIndex, endIndex) {
    var rangeSize = endIndex - startIndex | 0;
    if (this.isView(destination) && this.isView(source)) {
        var subrange = source.subarray(startIndex, endIndex);
        destination.set(subrange, destinationOffset);
    } else {
        if (source !== destination || destinationOffset <= startIndex) {
            for (var index = 0; index < rangeSize; index++) {
                destination[destinationOffset + index | 0] = source[startIndex + index | 0];
                Log.showInfo("Md5 copied ... source:" + source[startIndex + index | 0])
                Log.showInfo("Md5 copied ... destination:" + destination[destinationOffset + index | 0]);
            }
        } else {
            for (var index0 = rangeSize - 1 | 0; index0 >= 0; index0--) {
                destination[destinationOffset + index0 | 0] = source[startIndex + index0 | 0];
            }
        }
    }
    Log.showInfo("Md5 source:" + source + ",destination:" + destination);
}
Md5.prototype.fill = function ($receiver, element, fromIndex, toIndex) {
    if (fromIndex === void 0)
        fromIndex = 0;
    if (toIndex === void 0)
        toIndex = $receiver.length;
    $receiver.fill(element, fromIndex, toIndex);
}
Md5.prototype.toByte = function (a) {
    return (a & 255) << 24 >> 24;
}
