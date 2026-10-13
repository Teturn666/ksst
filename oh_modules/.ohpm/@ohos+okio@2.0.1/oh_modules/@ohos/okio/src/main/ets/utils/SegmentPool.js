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

import { Segment } from './Segment.js'
import { util } from './Utilities.js'

export function SegmentPool() {
    SegmentPoolInstance = this;
    this.MAX_SIZE = 0;
    this.byteCount = 0;
}
SegmentPool.prototype.take = function () {
    return segmentInit();
};
SegmentPool.prototype.recycle = function (segment) {
};
SegmentPool.$metadata$ = {
    kind: util.Kind.OBJECT,
    simpleName: 'SegmentPool',
    interfaces: []
};
var SegmentPoolInstance = null;

SegmentPool.prototype.segmentPoolGetInstance = function () {
    if (SegmentPoolInstance === null) {
        new SegmentPool();
    }
    return SegmentPoolInstance;
}

function segmentInit($this) {
    $this = $this || Object.create(Segment.prototype);
    Segment.call($this);
    $this.data = new Int8Array(8192);
    $this.owner = true;
    $this.shared = false;
    return $this;
}
