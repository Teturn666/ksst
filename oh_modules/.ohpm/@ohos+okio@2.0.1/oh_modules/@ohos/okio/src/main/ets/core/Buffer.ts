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

import BufferUtil from '../utils/BufferUtil.js';
import { util } from '../utils/Utilities.js';
import { SegmentPool } from '../utils/SegmentPool.js';
import Log from '../log.js';

var mIsInt = false;
var mIsIntLe = false;
var mIsShort = false;
var mIsShortLe = false;
var mIsByte = false;
var mIsString = false;

export function Buffer() {
    this.head = null;
    this.sizeDefault = util.Long.ZERO;
}

Object.defineProperty(Buffer.prototype, 'size', {
    configurable: true,
    get: function () {
        return this.sizeDefault;
    },
    set: function (size) {
        this.sizeDefault = size;
    }
});
Object.defineProperty(Buffer.prototype, 'buffer', {
    configurable: true,
    get: function () {
        return this;
    }
});

function isInteger(value, type) {
    var filter = /^(0|-?[1-9][0-9]*)$/.test(value);
    if (value >= -2147483648 && value <= 2147483647 && filter) {
        if (type == "intLe") mIsIntLe = true;
        else mIsInt = true;
    } else {
        if (type == "intLe") mIsIntLe = false;
        else mIsInt = false;
    }
}

function isShort(value, type) {
    var filter = /^(0|-?[1-9][0-9]*)$/.test(value);
    if (value >= -32768 && value <= 32767 && filter) {
        if (type == "shortLe") mIsShortLe = true;
        else mIsShort = true;
    } else {
        if (type == "shortLe") mIsShortLe = false;
        else mIsShort = false;
    }
}

function isByteValue(value) {
    var filter = /^(0|-?[1-9][0-9]*)$/.test(value);
    if (value >= -128 && value <= 127 && filter)
        mIsByte = true;
    else
        mIsByte = false;
}

Buffer.prototype.readShort = function () {
    if (mIsShort) {
        var commonReadShort$result;
        var L2 = util.Long.fromInt(2);
        var toShort = util.toShort;
        commonReadShort$break: do {
            var tmp, tmp0;
            if (this.size.compareTo11rb$(L2) < 0)
                return;
            var segment = util.ensureNotNull(this.head);
            var pos = segment.pos;
            var limit = segment.limit;
            if ((limit - pos | 0) < 2) {
                var s = (this.readByte() & 255) << 8 | this.readByte() & 255;
                commonReadShort$result = toShort(s);
                break commonReadShort$break;
            }
            var data = segment.data;
            var s0 = (data[tmp = pos, pos = tmp + 1 | 0, tmp] & 255) << 8
            | data[tmp0 = pos, pos = tmp0 + 1 | 0, tmp0] & 255;
            this.size = this.size.subtract(L2);
            if (pos === limit) {
                this.head = segment.pop();
                SegmentPool.prototype.segmentPoolGetInstance().recycle(segment);
            } else {
                segment.pos = pos;
            }
            commonReadShort$result = toShort(s0);
        }
        while (false);
        return commonReadShort$result;
    } else {
        return "Incorrect/No input present";
    }
};
Buffer.prototype.readInt = function () {
    if (mIsInt) {
        var commonReadInt$result;
        var L4 = util.Long.fromInt(4);
        commonReadInt$break: do {
            var tmp, tmp0, tmp1, tmp2;
            if (this.size.compareTo11rb$(L4) < 0)
                return;
            var segment = util.ensureNotNull(this.head);
            var pos = segment.pos;
            var limit = segment.limit;
            if ((limit - pos | 0) < L4.toNumber()) {
                commonReadInt$result = (this.readByte() & 255) << 24 | (this.readByte() & 255) << 16
                | (this.readByte() & 255) << 8 | this.readByte() & 255;
                break commonReadInt$break;
            }
            var data = segment.data;
            var i = (data[tmp = pos, pos = tmp + 1 | 0, tmp] & 255) << 24 | (data[tmp0 = pos, pos = tmp0 + 1 | 0, tmp0]
            & 255) << 16 | (data[tmp1 = pos, pos = tmp1 + 1 | 0, tmp1] & 255) << 8 | data[tmp2 = pos, pos = tmp2 + 1
            | 0, tmp2] & 255;
            this.size = this.size.subtract(L4);
            if (pos === limit) {
                this.head = segment.pop();
                SegmentPool.prototype.segmentPoolGetInstance().recycle(segment);
            } else {
                segment.pos = pos;
            }
            commonReadInt$result = i;
        }
        while (false);
        return commonReadInt$result;
    } else {
        return "Incorrect/No input present";
    }
};
Buffer.prototype.readShortLe = function () {
    if (mIsShortLe) {
        return BufferUtil.getInstance().reverseBytes(this.readShort());
    } else {
        return "Incorrect/No input present";
    }
};
Buffer.prototype.readIntLe = function () {
    if (mIsIntLe) {
        return BufferUtil.getInstance().reverseBytes0(this.readInt());
    } else {
        return "Incorrect/No input present";
    }
};

Buffer.prototype.readString = function () {
    return this.readUtf8();
}

Buffer.prototype.readUtf8 = function () {
    return this.readUtf8ByteCount(this.size);
};
Buffer.prototype.readUtf8ByteCount = function (byteCount) {
    var commonReadUtf8$result;
    commonReadUtf8$break: do {
        if (!(byteCount.toNumber() >= 0 && byteCount.toNumber() <= 2147483647)) {
            var message = 'byteCount: ' + byteCount.toString();
            return;
        }
        if (this.size.compareTo11rb$(byteCount) < 0)
            return;
        if (util.equals(byteCount, util.Long.ZERO)) {
            commonReadUtf8$result = '';
            break commonReadUtf8$break;
        }
        var s = util.ensureNotNull(this.head);
        if (util.Long.fromInt(s.pos).add(byteCount).toNumber() > s.limit) {
            commonReadUtf8$result = util.commonToUtf8String(this.readByteArray(byteCount));
            break commonReadUtf8$break;
        }
        var result = util.commonToUtf8String(s.data, s.pos, s.pos + byteCount.toInt() | 0);
        s.pos = s.pos + byteCount.toInt() | 0;
        this.size = this.size.subtract(byteCount);
        if (s.pos === s.limit) {
            this.head = s.pop();
            SegmentPool.prototype.segmentPoolGetInstance().recycle(s);
        }
        commonReadUtf8$result = result;
    }
    while (false);
    return commonReadUtf8$result;
};
Buffer.prototype.writableSegment = function (minimumCapacity) {
    var commonWritableSegment$result;
    commonWritableSegment$break: do {
        if (!(minimumCapacity >= 1 && minimumCapacity <= 8192)) {
            var message = 'unexpected capacity';
            return;
        }
        if (this.head == null) {
            var result = SegmentPool.prototype.segmentPoolGetInstance().take();
            this.head = result;
            result.prev = result;
            result.next = result;
            commonWritableSegment$result = result;
            break commonWritableSegment$break;
        }
        var tail = util.ensureNotNull(this.head).prev;
        if ((util.ensureNotNull(tail).limit + minimumCapacity | 0) > 8192 || !tail.owner) {
            tail = tail.push_uve4t5$(SegmentPool.prototype.segmentPoolGetInstance().take());
        }
        commonWritableSegment$result = tail;
    }
    while (false);
    return commonWritableSegment$result;
};

Buffer.prototype.writeString = function (string) {
    return this.writeSubString(string, 0, string.length)
}

Buffer.prototype.writeSubString = function (string, beginIndex, endIndex) {
    if (!(beginIndex >= 0)) {
        var message = 'beginIndex < 0: ' + beginIndex;
        return;
    }
    if (!(endIndex >= beginIndex)) {
        var message0 = 'endIndex < beginIndex: ' + endIndex + ' < ' + beginIndex;
        return;
    }
    if (!(endIndex <= string.length)) {
        var message1 = 'endIndex > string.length: ' + endIndex + ' > ' + string.length;
        return;
    }
    return this.writeUtf8BeginEndIndex(string, beginIndex, endIndex)
}

Buffer.prototype.writeUtf8 = function (string) {
    return this.writeUtf8BeginEndIndex(string, 0, string.length);
};
Buffer.prototype.writeUtf8BeginEndIndex = function (string, beginIndex, endIndex) {
    var tmp, tmp0;
    var L2 = util.Long.fromInt(2);
    var L3 = util.Long.fromInt(3);
    var L4 = util.Long.fromInt(4);
    if (!(beginIndex >= 0)) {
        var message = 'beginIndex < 0: ' + beginIndex;
        return;
    }
    if (!(endIndex >= beginIndex)) {
        var message0 = 'endIndex < beginIndex: ' + endIndex + ' < ' + beginIndex;
        return;
    }
    if (!(endIndex <= string.length)) {
        var message1 = 'endIndex > string.length: ' + endIndex + ' > ' + string.length;
        return;
    }
    var i = beginIndex;
    while (i < endIndex) {
        var c = string.charCodeAt(i) | 0;
        if (c < 128) {
            var tail = this.writableSegment(1);
            var data = tail.data;
            var segmentOffset = tail.limit - i | 0;
            var b = 8192 - segmentOffset | 0;
            var runLimit = Math.min(endIndex, b);
            data[segmentOffset + (tmp = i, i = tmp + 1 | 0, tmp) | 0] = util.toByte(c);
            while (i < runLimit) {
                c = string.charCodeAt(i) | 0;
                if (c >= 128)
                    break;
                data[segmentOffset + (tmp0 = i, i = tmp0 + 1 | 0, tmp0) | 0] = util.toByte(c);
            }
            var runSize = i + segmentOffset - tail.limit | 0;
            tail.limit = tail.limit + runSize | 0;
            this.size = this.size.add(util.Long.fromInt(runSize));
        } else if (c < 2048) {
            var tail0 = this.writableSegment(2);
            tail0.data[tail0.limit] = util.toByte(c >> 6 | 192);
            tail0.data[tail0.limit + 1 | 0] = util.toByte(c & 63 | 128);
            tail0.limit = tail0.limit + 2 | 0;
            this.size = this.size.add(L2);
            i = i + 1 | 0;
        } else if (c < 55296 || c > 57343) {
            var tail1 = this.writableSegment(3);
            tail1.data[tail1.limit] = util.toByte(c >> 12 | 224);
            tail1.data[tail1.limit + 1 | 0] = util.toByte(c >> 6 & 63 | 128);
            tail1.data[tail1.limit + 2 | 0] = util.toByte(c & 63 | 128);
            tail1.limit = tail1.limit + 3 | 0;
            this.size = this.size.add(L3);
            i = i + 1 | 0;
        } else {
            var low = (i + 1 | 0) < endIndex ? string.charCodeAt(i + 1 | 0) | 0 : 0;
            if (c > 56319 || !(56320 <= low && low <= 57343)) {
                this.writeByte(63);
                i = i + 1 | 0;
            } else {
                var codePoint = 65536 + ((c & 1023) << 10 | low & 1023) | 0;
                var tail2 = this.writableSegment(4);
                tail2.data[tail2.limit] = util.toByte(codePoint >> 18 | 240);
                tail2.data[tail2.limit + 1 | 0] = util.toByte(codePoint >> 12 & 63 | 128);
                tail2.data[tail2.limit + 2 | 0] = util.toByte(codePoint >> 6 & 63 | 128);
                tail2.data[tail2.limit + 3 | 0] = util.toByte(codePoint & 63 | 128);
                tail2.limit = tail2.limit + 4 | 0;
                this.size = this.size.add(L4);
                i = i + 2 | 0;
            }
        }
    }
    return this;
};
Buffer.prototype.writeShort = function (s) {
    isShort(s, "short");
    if (mIsShort) {
        var tmp, tmp0;
        var L2 = util.Long.fromInt(2);
        var tail = this.writableSegment(2);
        var data = tail.data;
        var limit = tail.limit;
        data[tmp = limit, limit = tmp + 1 | 0, tmp] = util.toByte(s >>> 8 & 255);
        data[tmp0 = limit, limit = tmp0 + 1 | 0, tmp0] = util.toByte(s & 255);
        tail.limit = limit;
        this.size = this.size.add(L2);
        return this;
    }
};
Buffer.prototype.writeShortLe = function (s) {
    isShort(s, "shortLe");
    if (mIsShortLe) {
        var toShort = util.toShort;
        return this.writeShort(BufferUtil.getInstance().reverseBytes(toShort(s)));
    }
};
Buffer.prototype.writeInt = function (i) {
    isInteger(i, "int");
    if (mIsInt) {
        var tmp, tmp0, tmp1, tmp2;
        var tail = this.writableSegment(4);
        var data = tail.data;
        var limit = tail.limit;
        var L4 = util.Long.fromInt(4);
        data[tmp = limit, limit = tmp + 1 | 0, tmp] = util.toByte(i >>> 24 & 255);
        data[tmp0 = limit, limit = tmp0 + 1 | 0, tmp0] = util.toByte(i >>> 16 & 255);
        data[tmp1 = limit, limit = tmp1 + 1 | 0, tmp1] = util.toByte(i >>> 8 & 255);
        data[tmp2 = limit, limit = tmp2 + 1 | 0, tmp2] = util.toByte(i & 255);
        tail.limit = limit;
        this.size = this.size.add(L4);
        return this;
    }
};
Buffer.prototype.writeIntLe = function (i) {
    isInteger(i, "intLe");
    if (mIsIntLe) {
        var temp = BufferUtil.getInstance();
        return this.writeInt(BufferUtil.getInstance().reverseBytes0(i));
    }
};

Buffer.prototype.readByte = function () {
    if (mIsByte) {
        var tmp;
        var L0 = util.Long.ZERO;
        var L1 = util.Long.fromInt(1);
        if (util.equals(this.size, L0)) {
            return;
        }
        var segment = util.ensureNotNull(this.head);
        var pos = segment.pos;
        var limit = segment.limit;
        var data = segment.data;
        var b = data[tmp = pos, pos = tmp + 1 | 0, tmp];
        this.size = this.size.subtract(L1);
        if (pos === limit) {
            this.head = segment.pop();
            SegmentPool.prototype.segmentPoolGetInstance().recycle(segment);
        } else {
            segment.pos = pos;
        }
        return b;
    } else {
        return "Incorrect/No input present";
    }
};

Buffer.prototype.writeByte = function (b) {
    isByteValue(b);
    if (mIsByte) {
        var tmp;
        var L1 = util.Long.fromInt(1);
        var tail = this.writableSegment(1);
        tail.data[tmp = tail.limit, tail.limit = tmp + 1 | 0, tmp] = util.toByte(b);
        this.size = this.size.add(L1);
        return this;
    }
};

Buffer.prototype.writeUtf8CodePoint = function (codePoint) {
    if (codePoint < 128)
        this.writeByte(codePoint);
    else if (codePoint < 2048) {
        var tail = this.writableSegment(2);
        var segment = util.ensureNotNull(this.head);
        tail.data[tail.limit] = util.toByte(codePoint >> 6 | 192);
        tail.data[tail.limit + 1 | 0] = util.toByte(codePoint & 63 | 128);
        tail.limit = tail.limit + 2 | 0;
        this.size = this.size.add(util.Long.fromInt(2));
    } else if (55296 <= codePoint && codePoint <= 57343)
        this.writeByte(63);
    else if (codePoint < 65536) {
        var tail0 = this.writableSegment(3);
        tail0.data[tail0.limit] = util.toByte(codePoint >> 12 | 224);
        tail0.data[tail0.limit + 1 | 0] = util.toByte(codePoint >> 6 & 63 | 128);
        tail0.data[tail0.limit + 2 | 0] = util.toByte(codePoint & 63 | 128);
        tail0.limit = tail0.limit + 3 | 0;
        this.size = this.size.add(util.Long.fromInt(3));
    } else if (codePoint <= 1114111) {
        var tail1 = this.writableSegment(4);
        tail1.data[tail1.limit] = util.toByte(codePoint >> 18 | 240);
        tail1.data[tail1.limit + 1 | 0] = util.toByte(codePoint >> 12 & 63 | 128);
        tail1.data[tail1.limit + 2 | 0] = util.toByte(codePoint >> 6 & 63 | 128);
        tail1.data[tail1.limit + 3 | 0] = util.toByte(codePoint & 63 | 128);
        tail1.limit = tail1.limit + 4 | 0;
        this.size = this.size.add(util.Long.fromInt(4));
    }
    return this;
};

Buffer.prototype.readUtf8CodePoint = function () {
    var commonReadUtf8CodePoint$result;
    commonReadUtf8CodePoint$break: do {
        var tmp, tmp0;
        if (util.equals(this.size, util.Long.fromInt(0))) {
            return "Incorrect/No input present";
        }
        var b0 = this.getCommonResult(util.Long.fromInt(0));
        var codePoint;
        var byteCount;
        var min;
        if ((b0 & 128) === 0) {
            codePoint = b0 & 127;
            byteCount = 1;
            min = 0;
        } else if ((b0 & 224) === 192) {
            codePoint = b0 & 31;
            byteCount = 2;
            min = 128;
        } else if ((b0 & 240) === 224) {
            codePoint = b0 & 15;
            byteCount = 3;
            min = 2048;
        } else if ((b0 & 248) === 240) {
            codePoint = b0 & 7;
            byteCount = 4;
            min = 65536;
        } else {
            this.skipByteCount(util.Long.fromInt(1));
            commonReadUtf8CodePoint$result = 65533;
            break commonReadUtf8CodePoint$break;
        }
        tmp = byteCount;
        for (var i = 1; i < tmp; i++) {
            var b = this.getCommonResult(util.Long.fromInt(i));
            if ((b & 192) === 128) {
                codePoint = codePoint << 6;
                codePoint = codePoint | b & 63;
            } else {
                this.skipByteCount(util.Long.fromInt(i));
                commonReadUtf8CodePoint$result = 65533;
                break commonReadUtf8CodePoint$break;
            }
        }
        if (codePoint > 1114111)
            tmp0 = 65533;
        else if (55296 <= codePoint && codePoint <= 57343)
            tmp0 = 65533;
        else if (codePoint < min)
            tmp0 = 65533;
        else
            tmp0 = codePoint;
        commonReadUtf8CodePoint$result = tmp0;
    }
    while (false);
    return commonReadUtf8CodePoint$result;
};
Buffer.prototype.getCommonResult = function (pos) {
    var commonGet$result;
    commonGet$break: do {
        var L1 = util.Long.fromInt(1);
        var L0 = util.Long.ZERO;
        var L_1 = util.Long.NEG_ONE;
        checkOffsetAndCount(this.size, pos, L1);
        var tmp;
        tmp = this.head;
        if (tmp == null) {
            var offset = L_1;
            commonGet$result = util.ensureNotNull(null).data[util.Long.fromInt(1).add(pos).subtract(offset).toInt()];
            break commonGet$break;
        }
        var s = tmp;
        if (this.size.subtract(pos).compareTo11rb$(pos) < 0) {
            var offset0 = this.size;
            while (offset0.compareTo11rb$(pos) > 0) {
                s = util.ensureNotNull(s.prev);
                offset0 = offset0.subtract(util.Long.fromInt(s.limit - s.pos | 0));
            }
            var s0 = s;
            var offset1 = offset0;
            commonGet$result = util.ensureNotNull(s0).data[util.Long.fromInt(s0.pos).add(pos).subtract(offset1).toInt()];
        } else {
            var offset2 = L0;
            while (true) {
                var nextOffset = offset2.add(util.Long.fromInt(s.limit - s.pos | 0));
                if (nextOffset.compareTo11rb$(pos) > 0)
                    break;
                s = util.ensureNotNull(s.next);
                offset2 = nextOffset;
            }
            var s1 = s;
            var offset3 = offset2;
            commonGet$result = util.ensureNotNull(s1).data[util.Long.fromInt(s1.pos).add(pos).subtract(offset3).toInt()];
        }
    }
    while (false);
    return commonGet$result;
};

function checkOffsetAndCount(size, offset, byteCount) {
}

Buffer.prototype.skipByteCount = function (byteCount) {
    var tmp;
    var byteCount0 = byteCount;
    while (byteCount0.toNumber() > 0) {
        tmp = this.head;
        if (tmp == null) {
            Log.showError("EOFException");
            return;
        }
        var head = tmp;
        var a = byteCount0;
        var b = util.Long.fromInt(head.limit - head.pos | 0);
        var toSkip = (a.compareTo11rb$(b) <= 0 ? a : b).toInt();
        this.size = this.size.subtract(util.Long.fromInt(toSkip));
        byteCount0 = byteCount0.subtract(util.Long.fromInt(toSkip));
        head.pos = head.pos + toSkip | 0;
        if (head.pos === head.limit) {
            this.head = head.pop();
            SegmentPool.prototype.segmentPoolGetInstance().recycle(head);
        }
    }
};

Buffer.prototype.readByteArray = function (byteCount) {
    if (!(byteCount.toNumber() >= 0 && byteCount.toNumber() <= 2147483647)) {
        var message = 'byteCount: ' + byteCount.toString();
        return;
    }
    if (this.size.compareTo11rb$(byteCount) < 0) {
        return;
    }
    var result = new Int8Array(byteCount.toInt());
    this.readFully(result);
    return result;
};
Buffer.prototype.readFully = function (sink) {
    var offset = 0;
    while (offset < sink.length) {
        var read = this.read(sink, offset, sink.length - offset | 0);
        if (read === -1) {
            return;
        }
        offset = offset + read | 0;
    }
};
Buffer.prototype.read = function (sink, offset, byteCount) {
    var arrayCopy = util.collections.arrayCopy;
    var commonRead$result;
    commonRead$break: do {
        var tmp;
        checkOffsetAndCount(util.Long.fromInt(sink.length), util.Long.fromInt(offset), util.Long.fromInt(byteCount));
        tmp = this.head; // this should give all values
        if (tmp == null) {
            commonRead$result = -1;
            break commonRead$break;
        }
        var s = tmp;
        var b = s.limit - s.pos | 0;
        var JsMath = Math;
        var toCopy = JsMath.min(byteCount, b);
        arrayCopy(s.data, sink, offset, s.pos, s.pos + toCopy | 0);
        s.pos = s.pos + toCopy | 0;
        this.size = this.size.subtract(util.Long.fromInt(toCopy));
        if (s.pos === s.limit) {
            this.head = s.pop();
        }
        commonRead$result = toCopy;
    }
    while (false);
    return commonRead$result;
};