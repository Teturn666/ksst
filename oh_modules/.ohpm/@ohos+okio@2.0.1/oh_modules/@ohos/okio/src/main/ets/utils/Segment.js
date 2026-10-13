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
import { SegmentPool } from './SegmentPool.js';

export function Segment() {
    segmentCompanionGetInstance();
    this.data = null;
    this.pos = 0;
    this.limit = 0;
    this.shared = false;
    this.owner = false;
    this.next = null;
    this.prev = null;
}
Segment.prototype.sharedCopy = function () {
    this.shared = true;
    return segmentInit0(this.data, this.pos, this.limit, true, false);
};
Segment.prototype.unsharedCopy = function () {
    return segmentInit0(this.data.slice(), this.pos, this.limit, false, true);
};
Segment.prototype.pop = function () {
    var result = this.next !== this ? this.next : null;
    util.ensureNotNull(this.prev).next = this.next;
    util.ensureNotNull(this.next).prev = this.prev;
    this.next = null;
    this.prev = null;
    return result;
};
Segment.prototype.push = function (segment) {
    segment.prev = this;
    segment.next = this.next;
    util.ensureNotNull(this.next).prev = segment;
    this.next = segment;
    return segment;
};
Segment.prototype.split = function (byteCount) {
    var arrayCopy = util.collections.arrayCopy;
    if (!(byteCount > 0 && byteCount <= (this.limit - this.pos | 0))) {
        var message = 'byteCount out of range';
        throw util.illegalArgumentExceptionInit(message.toString());
    }
    var prefix;
    if (byteCount >= 1024) {
        prefix = this.sharedCopy();
    } else {
        prefix = SegmentPool.segmentPoolGetInstance().take();
        arrayCopy(this.data, prefix.data, 0, this.pos, this.pos + byteCount | 0);
    }
    prefix.limit = prefix.pos + byteCount | 0;
    this.pos = this.pos + byteCount | 0;
    util.ensureNotNull(this.prev).push(prefix);
    return prefix;
};
Segment.prototype.compact = function () {
    if (!(this.prev !== this)) {
        var message = 'cannot compact';
        throw util.illegalStateExceptionInit(message.toString());
    }
    if (!util.ensureNotNull(this.prev).owner)
        return;
    var byteCount = this.limit - this.pos | 0;
    var availableByteCount = 8192 - util.ensureNotNull(this.prev).limit +
    (util.ensureNotNull(this.prev).shared ? 0 : util.ensureNotNull(this.prev).pos) | 0;

    if (byteCount > availableByteCount)
        return;
    this.writeTo(util.ensureNotNull(this.prev), byteCount);
    this.pop();
    SegmentPool.segmentPoolGetInstance().recycle(this);
};
Segment.prototype.writeTo = function (sink, byteCount) {
    var arrayCopy = util.collections.arrayCopy;
    if (!sink.owner) {
        var message = 'only owner can write';
        throw util.illegalStateExceptionInit(message.toString());
    }
    if ((sink.limit + byteCount | 0) > 8192) {
        if (sink.shared)
            throw util.illegalArgumentExceptionInit0();
        if ((sink.limit + byteCount - sink.pos | 0) > 8192)
            throw util.illegalArgumentExceptionInit0();
        arrayCopy(sink.data, sink.data, 0, sink.pos, sink.limit);
        sink.limit = sink.limit - sink.pos | 0;
        sink.pos = 0;
    }
    arrayCopy(this.data, sink.data, sink.limit, this.pos, this.pos + byteCount | 0);
    sink.limit = sink.limit + byteCount | 0;
    this.pos = this.pos + byteCount | 0;
};

function Segment$Companion() {
    segmentCompanionInstance = this;
    this.SIZE = 8192;
    this.SHARE_MINIMUM = 1024;
}

Segment$Companion.$metadata$ = {
    kind: util.Kind.kindObject,
    simpleName: 'Companion',
    interfaces: []
};
var segmentCompanionInstance = null;

function segmentCompanionGetInstance() {
    if (segmentCompanionInstance === null) {
        new Segment$Companion();
    }
    return segmentCompanionInstance;
}

Segment.$metadata$ = {
    kind: util.Kind.kindClass,
    simpleName: 'Segment',
    interfaces: []
};

function segmentInit0(data, pos, limit, shared, owner, $this) {
    $this = $this || Object.create(Segment.prototype);
    Segment.call($this);
    $this.data = data;
    $this.pos = pos;
    $this.limit = limit;
    $this.shared = shared;
    $this.owner = owner;
    return $this;
}