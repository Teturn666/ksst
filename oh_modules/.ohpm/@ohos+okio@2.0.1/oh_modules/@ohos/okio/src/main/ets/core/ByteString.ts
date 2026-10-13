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

import { util } from '../utils/Utilities.js';
import Log from '../log.js';
import { hex } from '../utils/Hex.js'
import { Md5 } from '../utils/MD5.js'

var byteString = {};

var byteStringFunction = function (_, Util) {

    'use strict';
    var L6 = Util.Long.fromInt(6);
    var L8 = Util.Long.fromInt(8);
    var CharRange = Util.util.ranges.CharRange;
    var toByte = Util.toByte;
    var copyOf = Util.util.collections.copyOfmrm5p;
    var concatToString = Util.util.text.concatToString355ntz;
    var IndexOutOfBoundsException = Util.util.IndexOutOfBoundsException;

    var kindClass = Util.Kind.CLASS;
    var illegalArgumentException = Util.util.IllegalArgumentExceptioninitpdl1vj;
    var Throwable = Error;
    var kindObject = Util.Kind.OBJECT;
    var JsMath = Math;
    var arrayCopy = Util.util.collections.arrayCopy;
    var Comparable = Util.util.Comparable;
    var copyOfRange = Util.util.collections.copyOfRange_ietg8x$;
    var contentHashCode = Util.arrayHashCode;
    var replace = Util.util.text.replace680rmw;
    var BASE64;
    var REPLACEMENT_BYTE;
    var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    function encodeBase64(bytes) {
        let i,
            len = bytes.length,
            base64 = "";

        for (i = 0; i < len; i += 3) {
            base64 += chars[bytes[i] >> 2];
            base64 += chars[((bytes[i] & 3) << 4) | (bytes[i + 1] >> 4)];
            base64 += chars[((bytes[i + 1] & 15) << 2) | (bytes[i + 2] >> 6)];
            base64 += chars[bytes[i + 2] & 63];
        }

        if (len % 3 === 2) {
            base64 = base64.substring(0, base64.length - 1) + "=";
        } else if (len % 3 === 1) {
            base64 = base64.substring(0, base64.length - 2) + "==";
        }

        return base64;
    }

    function decodeBase64ToArray($receiver) {
        var tmp, tmp0, tmp1, tmp2, tmp3, tmp4, tmp5;
        var limit = $receiver.length;
        while (limit > 0) {
            var c = $receiver.charCodeAt(limit - 1 | 0);
            if (c !== 61 && c !== 10 && c !== 13 && c !== 32 && c !== 9) {
                break;
            }
            limit = limit - 1 | 0;
        }
        var out = new Int8Array(Util.Long.fromInt(limit).multiply(L6).div(L8).toInt());
        var outCount = 0;
        var inCount = 0;
        var word = 0;
        tmp = limit;
        for (var pos = 0; pos < tmp; pos++) {
            var c0 = $receiver.charCodeAt(pos);
            var bits;
            if ((new CharRange(65, 90)).containsmef7kx$(c0)) {
                bits = (c0 | 0) - 65 | 0;
            } else if ((new CharRange(97, 122)).containsmef7kx$(c0)) {
                bits = (c0 | 0) - 71 | 0;
            } else if ((new CharRange(48, 57)).containsmef7kx$(c0)) {
                bits = (c0 | 0) + 4 | 0;
            } else if (c0 === 43 || c0 === 45) {
                bits = 62;
            } else if (c0 === 47 || c0 === 95) {
                bits = 63;
            } else if (c0 === 10 || c0 === 13 || c0 === 32 || c0 === 9) {
                //continue;
            } else {
                return null;
            }
            if (c0 != 10 || c0 != 13 || c0 != 32 || c0 != 9) {
                word = word << 6 | bits;
                inCount = inCount + 1 | 0;
                if (inCount % 4 === 0) {
                    out[tmp0 = outCount, outCount = tmp0 + 1 | 0, tmp0] = toByte(word >> 16);
                    out[tmp1 = outCount, outCount = tmp1 + 1 | 0, tmp1] = toByte(word >> 8);
                    out[tmp2 = outCount, outCount = tmp2 + 1 | 0, tmp2] = toByte(word);
                }
            }
        }
        var lastWordChars = inCount % 4;
        switch (lastWordChars) {
            case 1:
                return null;
            case 2:
                word = word << 12;
                out[tmp3 = outCount, outCount = tmp3 + 1 | 0, tmp3] = toByte(word >> 16);
                break;
            case 3:
                word = word << 6;
                out[tmp4 = outCount, outCount = tmp4 + 1 | 0, tmp4] = toByte(word >> 16);
                out[tmp5 = outCount, outCount = tmp5 + 1 | 0, tmp5] = toByte(word >> 8);
                break;
        }
        if (outCount === out.length)
            return out;
        return copyOf(out, outCount);
    }

    function decodeHexDigit(c) {
        var tmp;
        if ((new CharRange(48, 57)).containsmef7kx$(c))
            tmp = c - 48;
        else if ((new CharRange(97, 102)).containsmef7kx$(c))
            tmp = c - 97 + 10 | 0;
        else if ((new CharRange(65, 70)).containsmef7kx$(c))
            tmp = c - 65 + 10 | 0;
        else
            throw illegalArgumentException('Unexpected hex digit: ' + String.fromCharCode(c));
        return tmp;
    }

    function asUtf8ToByteArray($receiver) {
        return commonAsUtf8ToByteArray($receiver);
    }

    function ArrayIndexOutOfBoundsException(message) {
        IndexOutOfBoundsException.call(this, message);
        this.name = 'ArrayIndexOutOfBoundsException';
    }

    function commonAsUtf8ToByteArray($receiver) {
        var bytes = new Int8Array(4 * $receiver.length | 0);
        var tmp = $receiver.length;
        for (var index = 0; index < tmp; index++) {
            if ($receiver.charCodeAt(index) >= 128) {
                var size = { v: index };
                var endIndex = $receiver.length;
                var tmp0;
                var index0 = index;
                while (index0 < endIndex) {
                    var c = $receiver.charCodeAt(index0);
                    if (c < 128) {
                        var c0 = toByte(c | 0);
                        var tmp1;
                        bytes[tmp1 = size.v, size.v = tmp1 + 1 | 0, tmp1] = c0;
                        index0 = index0 + 1 | 0;
                        while (index0 < endIndex && $receiver.charCodeAt(index0) < 128) {
                            var c1 = toByte($receiver.charCodeAt((tmp0 = index0,
                            index0 = tmp0 + 1 | 0, tmp0)) | 0);
                            var tmp2;
                            bytes[tmp2 = size.v, size.v = tmp2 + 1 | 0, tmp2] = c1;
                        }
                    } else if (c < 2048) {
                        var c2 = toByte((c | 0) >> 6 | 192);
                        var tmp3, tmp4;
                        bytes[tmp3 = size.v, size.v = tmp3 + 1 | 0, tmp3] = c2;
                        var c3 = toByte((c | 0) & 63 | 128);
                        bytes[tmp4 = size.v, size.v = tmp4 + 1 | 0, tmp4] = c3;
                        index0 = index0 + 1 | 0;
                    } else if (!(new CharRange(55296, 57343)).containsmef7kx$(c)) {
                        var c4 = toByte((c | 0) >> 12 | 224);
                        var tmp5, tmp6, tmp7;
                        bytes[tmp5 = size.v, size.v = tmp5 + 1 | 0, tmp5] = c4;
                        var c5 = toByte((c | 0) >> 6 & 63 | 128);
                        bytes[tmp6 = size.v, size.v = tmp6 + 1 | 0, tmp6] = c5;
                        var c6 = toByte((c | 0) & 63 | 128);
                        bytes[tmp7 = size.v, size.v = tmp7 + 1 | 0, tmp7] = c6;
                        index0 = index0 + 1 | 0;
                    } else if (c > 56319 || endIndex <= (index0 + 1 | 0)
                    || !(new CharRange(56320, 57343)).containsmef7kx$($receiver.charCodeAt(index0 + 1 | 0))) {
                        var c7 = package$okio.REPLACEMENT_BYTE_8be2vx$;
                        var tmp8;
                        bytes[tmp8 = size.v, size.v = tmp8 + 1 | 0, tmp8] = c7;
                        index0 = index0 + 1 | 0;
                    } else {
                        var codePoint = ((c | 0) << 10) + ($receiver.charCodeAt(index0 + 1 | 0) | 0)
                        + -56613888 | 0;
                        var c8 = toByte(codePoint >> 18 | 240);
                        var tmp9, tmp10, tmp11, tmp12;
                        bytes[tmp9 = size.v, size.v = tmp9 + 1 | 0, tmp9] = c8;
                        var c9 = toByte(codePoint >> 12 & 63 | 128);
                        bytes[tmp10 = size.v, size.v = tmp10 + 1 | 0, tmp10] = c9;
                        var c10 = toByte(codePoint >> 6 & 63 | 128);
                        bytes[tmp11 = size.v, size.v = tmp11 + 1 | 0, tmp11] = c10;
                        var c11 = toByte(codePoint & 63 | 128);
                        bytes[tmp12 = size.v, size.v = tmp12 + 1 | 0, tmp12] = c11;
                        index0 = index0 + 2 | 0;
                    }
                }
                return copyOf(bytes, size.v);
            }
            bytes[index] = toByte($receiver.charCodeAt(index) | 0);
        }
        return copyOf(bytes, $receiver.length);
    }

    var package$okio = _.okio || (_.okio = {});
    REPLACEMENT_BYTE = toByte(63 | 0);

    Object.defineProperty(package$okio, 'REPLACEMENT_BYTE_8be2vx$', {
        get: function () {
            return REPLACEMENT_BYTE;
        }
    });

    function ByteString(data) {
        getByteStringCompanion();
        this.data = data;
        this.hashValue = 0;
    }

    Object.defineProperty(ByteString.prototype, 'hashCode8b', {
        configurable: true,
        get: function () {
            return this.hashValue;
        },
        set: function (value) {
        }
    });

    ByteString.prototype.toAsciiLowercase = function (data) {
        if (data === undefined || data === null || data.length === 0) {
            Log.showError('Invalid toAsciiLowercase input');
            return;
        }
        this.data = data;
        var lowercase = this.data.toString().toLowerCase().slice();
        var commonToAsciiLowercase$result = new Array();
        for (var i = 0; i < lowercase.length; i++) {
            commonToAsciiLowercase$result[i] = lowercase.charCodeAt(i);
        }
        return new ByteString(commonToAsciiLowercase$result);
    };

    ByteString.prototype.toAsciiUppercase = function (data) {
        if (data === undefined || data === null || data.length === 0) {
            Log.showError('Invalid toAsciiUppercase input');
            return;
        }
        this.data = data;
        var uppercase = this.data.toString().toUpperCase().slice();
        var commonToAsciiUppercase$result = new Array();
        for (var i = 0; i < uppercase.length; i++) {
            commonToAsciiUppercase$result[i] = uppercase.charCodeAt(i);
        }
        return new ByteString(commonToAsciiUppercase$result);
    };
    ByteString.prototype.internalGet = function (pos) {
        if (pos >= this.size || pos < 0) {
            Log.showError('ArrayIndexOutOfBoundsException size=' + this.size + ' pos=' + pos);
        }
        return this.data[pos];
    };
    ByteString.prototype.getWithIndex = function (index) {
        return this.internalGet(index);
    };
    Object.defineProperty(ByteString.prototype, 'size', {
        configurable: true,
        get: function () {
            return this.getSize();
        }
    });

    ByteString.prototype.getSize = function () {
        if (this.data === undefined || this.data === null) {
            Log.showError('Invalid getSize input');
            return;
        }
        return this.data.length;
    };

    ByteString.prototype.toByteArray = function () {
        if (this.data === undefined || this.data === null || this.data.length === 0) {
            Log.showError('Invalid toByteArray input');
            return;
        }
        return this.data.slice();
    };

    ByteString.prototype.internalArray = function () {
        if (this.data === undefined || this.data === null || this.data.length === 0) {
            Log.showError('Invalid toAsciiLowercase input');
            return;
        }
        return this.data;
    };

    ByteString.prototype.hashCode = function () {
        var commonHashCode$result;
        commonHashCode$break: do {
            var result = this.hashCode8b;
            if (result !== 0) {
                commonHashCode$result = result;
                break commonHashCode$break;
            }
            var $receiver = contentHashCode(this.data);
            this.hashCode8b = $receiver;
            commonHashCode$result = $receiver;
        }
        while (false);
        return commonHashCode$result;
    };

    ByteString.prototype.compareToOther = function (other) {
        if (other === undefined || other === null || other.length === 0) {
            Log.showError('Invalid compareToOther input');
            return;
        }
        var commonCompareTo$result;
        commonCompareTo$break: do {
            var sizeA = this.size;
            var sizeB = other.size;
            var i = 0;
            var size = JsMath.min(sizeA, sizeB);
            while (i < size) {
                var byteA = this.data.charCodeAt(i) & 255;
                var byteB = other.data.charCodeAt(i) & 255;
                if (byteA === byteB) {
                    i = i + 1 | 0;
                } else {
                    commonCompareTo$result = byteA < byteB ? -1 : 1;
                    break commonCompareTo$break;
                }
            }
            if (sizeA === sizeB) {
                commonCompareTo$result = 0;
                break commonCompareTo$break;
            }
            commonCompareTo$result = sizeA < sizeB ? -1 : 1;
        }
        while (false);
        return commonCompareTo$result;
    };

    function ByteString$Companion() {
        byteStringCompanion = this;
        this.EMPTY = new ByteString(new Int8Array([]));
    }

    ByteString.prototype.of = function (data) {
        if (data === undefined || data === null || data.length === 0) {
            Log.showError('Invalid of input');
            return;
        }
        return new ByteString(data.slice());
    };
    ByteString.prototype.encodeUtf8 = function ($receiver) {
        if ($receiver === undefined || $receiver === null || $receiver.length === 0) {
            Log.showError('Invalid encodeUtf8 input');
            return;
        }
        var byteString = new ByteString(asUtf8ToByteArray($receiver));
        byteString.utf8 = $receiver;
        return byteString;
    };
    ByteString.prototype.decodeBase64 = function ($receiver) {
        if ($receiver === undefined || $receiver === null || $receiver.length === 0) {
            Log.showError('Invalid decodeBase64 input');
            return;
        }
        var decoded = decodeBase64ToArray($receiver);
        return decoded != null ? new ByteString(decoded) : null;
    };
    ByteString.prototype.Base64 = function () {
        if (this.data === undefined || this.data === null || this.data.length === 0) {
            Log.showError('Invalid encodeBase64 input');
            return;
        }
        return encodeBase64(this.data);
    };
    ByteString.prototype.Hex = function () {
        if (this.data === undefined || this.data === null || this.data.length === 0) {
            Log.showError('Invalid encode Hex input');
            return;
        }
        let encoded = hex(this.data);
        return encoded;
    };
    ByteString.prototype.md5 = function () {
        if (this.data === undefined || this.data === null || this.data.length === 0) {
            Log.showError('Invalid encode Hex input');
            return;
        }
        let data = this.data
        var md = new Md5();
        md.update(data, 0, data.length);
        let encoded = md.digest();
        return new ByteString(encoded);
    };
    ByteString.prototype.decodeHex = function ($receiver) {
        if ($receiver === undefined || $receiver === null || $receiver.length === 0 || $receiver.length % 2 != 0) {
            Log.showError('Invalid decodeHex input');
            return;
        }
        var result = new Int8Array($receiver.length / 2 | 0);
        for (var i = 0; i !== result.length; ++i) {
            try {
                var d1 = decodeHexDigit($receiver.charCodeAt(i * 2 | 0)) << 4;
                var d2 = decodeHexDigit($receiver.charCodeAt((i * 2 | 0) + 1 | 0));
                result[i] = toByte(d1 + d2 | 0);
            } catch (e) {
                Log.showError('Invalid decodeHex input');
                return;
            }
        }
        return new ByteString(result);
    };

    ByteString$Companion.$metadata$ = {
        kind: kindObject,
        simpleName: 'Companion',
        interfaces: []
    };

    var byteStringCompanion = null;

    function getByteStringCompanion() {
        if (byteStringCompanion === null) {
            new ByteString$Companion();
        }
        return byteStringCompanion;
    }

    ByteString.$metadata$ = {
        kind: kindClass,
        simpleName: 'ByteString',
        interfaces: [Comparable]
    };
    return { ByteString, ByteString$Companion }
}

export var ByteString = byteStringFunction(byteString, util);