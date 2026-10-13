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

import fileio from '@ohos.fileio';
import Log from '../log.js';

var filePath = null;
var fileDescriptor = null;
var buffer = null;

export default class Source {
    filePath: string = ''

    constructor(filePath) {
        this.filePath = filePath;
        fileDescriptor = fileio.openSync(this.filePath, 0o102, 0o666);
    }

    read() {
        var context = this;
        return new Promise(function (resolve, reject) {
            try {
                let stat = fileio.statSync(context.filePath)
                let length = stat.size || 4096;
                let buf = new ArrayBuffer(length);
                let ss = fileio.createStreamSync(context.filePath, "r+");
                ss.readSync(buf)
                ss.closeSync();
                let data = context.convertUtf(new Uint8Array(buf));
                if (data != null)
                    resolve(data);
                else
                    reject(data);
            } catch (e) {
                Log.showError("Source read Error -  " + e);
                reject(e);
            }
        });
    }

    convertUtf(utf8Bytes) {
        try {
            var unicodeStr = "";
            for (var pos = 0; pos < utf8Bytes.length; ) {
                var flag = utf8Bytes[pos];
                var unicode = 0;
                if ((flag >>> 7) === 0) {
                    unicodeStr += String.fromCharCode(utf8Bytes[pos]);
                    pos += 1;
                } else if ((flag & 0xFC) === 0xFC) {
                    unicode = (utf8Bytes[pos] & 0x3) << 30;
                    unicode |= (utf8Bytes[pos+1] & 0x3F) << 24;
                    unicode |= (utf8Bytes[pos+2] & 0x3F) << 18;
                    unicode |= (utf8Bytes[pos+3] & 0x3F) << 12;
                    unicode |= (utf8Bytes[pos+4] & 0x3F) << 6;
                    unicode |= (utf8Bytes[pos+5] & 0x3F);
                    unicodeStr += String.fromCharCode(unicode);
                    pos += 6;
                } else if ((flag & 0xF8) === 0xF8) {
                    unicode = (utf8Bytes[pos] & 0x7) << 24;
                    unicode |= (utf8Bytes[pos+1] & 0x3F) << 18;
                    unicode |= (utf8Bytes[pos+2] & 0x3F) << 12;
                    unicode |= (utf8Bytes[pos+3] & 0x3F) << 6;
                    unicode |= (utf8Bytes[pos+4] & 0x3F);
                    unicodeStr += String.fromCharCode(unicode);
                    pos += 5;
                } else if ((flag & 0xF0) === 0xF0) {
                    unicode = (utf8Bytes[pos] & 0xF) << 18;
                    unicode |= (utf8Bytes[pos+1] & 0x3F) << 12;
                    unicode |= (utf8Bytes[pos+2] & 0x3F) << 6;
                    unicode |= (utf8Bytes[pos+3] & 0x3F);
                    unicodeStr += String.fromCharCode(unicode);
                    pos += 4;
                } else if ((flag & 0xE0) === 0xE0) {
                    unicode = (utf8Bytes[pos] & 0x1F) << 12;
                    unicode |= (utf8Bytes[pos+1] & 0x3F) << 6;
                    unicode |= (utf8Bytes[pos+2] & 0x3F);
                    unicodeStr += String.fromCharCode(unicode);
                    pos += 3;
                } else if ((flag & 0xC0) === 0xC0) {
                    unicode = (utf8Bytes[pos] & 0x3F) << 6;
                    unicode |= (utf8Bytes[pos+1] & 0x3F);
                    unicodeStr += String.fromCharCode(unicode);
                    pos += 2;
                } else {
                    unicodeStr += String.fromCharCode(utf8Bytes[pos]);
                    pos += 1;
                }
            }
            return unicodeStr;
        } catch (error) {
            Log.showError("Source read Error -  " + error);
            return null;
        }
    }
}