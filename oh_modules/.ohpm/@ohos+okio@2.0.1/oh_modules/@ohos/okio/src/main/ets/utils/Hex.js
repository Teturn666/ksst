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

var HEX_DIGIT_CHARS = charArrayOf(48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 97, 98, 99, 100, 101, 102);

export function hex(data) {
    var tmp, tmp0, tmp1, tmp2;
    var result = charArray(data.length * 2 | 0);
    var c = 0;
    tmp = data;
    for (tmp0 = 0; tmp0 !== tmp.length; ++tmp0) {
        var b = tmp[tmp0];
        result[tmp1 = c, c = tmp1 + 1 | 0, tmp1] = HEX_DIGIT_CHARS[b >> 4 & 15];
        result[tmp2 = c, c = tmp2 + 1 | 0, tmp2] = HEX_DIGIT_CHARS[b & 15];
    }
    return concatToString(result);
}

function charArrayOf() {
    var type = 'CharArray';
    var array = new Uint16Array([].slice.call(arguments));
    array.$type$ = type;
    return array;
}

function concatToString($receiver) {
    var tmp;
    var result = '';
    for (tmp = 0; tmp !== $receiver.length; ++tmp) {
        var char = unboxChar($receiver[tmp]);
        result += String.fromCharCode(char);
    }
    return result;
}

function toChar(a) {
    return a & 65535;
}

function unboxChar(a) {
    if (a == null)
        return a;
    return toChar(a);
}

function charArray(size, init) {
    var tmp;
    var result = new Uint16Array(size);
    result.$type$ = 'CharArray';
    if (init == null || equals(init, true) || equals(init, false))
        tmp = result;
    else {
        var tmp0;
        tmp0 = result.length - 1 | 0;
        for (var i = 0; i <= tmp0; i++) {
            result[i] = init(i);
        }
        tmp = result;
    }
    return tmp;
}