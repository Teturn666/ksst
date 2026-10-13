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

var BufferUtilInstance = null;

export default class BufferUtil {
    constructor() {
        BufferUtilInstance = this;
    }

    static getInstance() {
        if (BufferUtilInstance === null) {
            new BufferUtil();
        }
        return BufferUtilInstance;
    }

    reverseBytes0($receiver) {
        return ($receiver & -16777216) >>> 24 | ($receiver & 16711680) >>> 8
        | ($receiver & 65280) << 8 | ($receiver & 255) << 24;
    }

    reverseBytes($receiver) {
        var toShort = util.toShort;
        var i = $receiver & 65535;
        var reversed = (i & 65280) >>> 8 | (i & 255) << 8;
        return toShort(reversed);
    }

    equalsLong = function (v1, v2) {
        return v1.high_ == v2.high_ && v1.low_ == v2.low_;
    };
    isNegative = function () {
        return this.high_ < 0;
    };
}