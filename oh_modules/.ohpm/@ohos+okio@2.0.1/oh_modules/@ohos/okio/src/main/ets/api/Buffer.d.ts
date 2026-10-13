/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * the Buffer Object
 * @name Buffer
 * @since 1.0.0
 * @sysCap AAFwk
 * @devices phone, tablet
 * @permission N/A
 */
declare namespace Buffer {

/**
 * write Utf8 data.
 *
 * @devices phone, tablet
 * @since 1.0.0
 * @sysCap AAFwk
 * @param data: The data to be written in Buffer
 * @return - Buffer
 */
    function writeUtf8(data: string): Buffer;

    /**
     * read Utf8 data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @return Returns the Utf8 data
     */
    function readUtf8(): string;

    /**
     * write int data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param data: int data to be written in Buffer
     * @return - Buffer
     */
    function writeInt(data): Buffer;

    /**
     * read int data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @return Returns the int data
     */
    function readInt(): var

    int;

    /**
     * write string data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param data: The data to be written in Buffer
     * @return Buffer
     */
    function writeString(data: string): Buffer;

    /**
     * read string data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @return Returns the string data
     */
    function readString(): string;

    /**
     * write intLe data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param data: intLe data to be written in Buffer
     * @return Buffer
     */
    function writeIntLe(data): var

    Buffer;

    /**
     * read intLe data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @return Returns the intLe data
     */
    function readIntLe(): var

    intLe;

    /**
     * write shortLe data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param data: shortLe data to be written in Buffer
     * @return Buffer
     */
    function writeShortLe(data): var

    Buffer;

    /**
     * read Utf8 shortLe.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @return Returns the shortLe data
     */
    function readShortLe(): var

    shortLe;

    /**
     * write short data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param data: short data to be written in Buffer
     * @return Buffer
     */
    function writeShort(data): var

    Buffer;

    /**
     * read short data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @return Returns the short data
     */
    function readShort(): var

    short;

    /**
     * write byte data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param data: byte data to be written in Buffer
     * @return Buffer
     */
    function writeByte(data): var

    Buffer;

    /**
     * read byte data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @return Returns the byte data
     */
    function readByte(): var

    byte;

    /**
     * write Utf8CodePoint data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param data: Utf8CodePoint data to be written in Buffer
     * @return Buffer
     */
    function writeUtf8CodePoint(data): var

    Buffer;

    /**
     * read Utf8CodePoint data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @return Utf8CodePoint data
     */
    function readUtf8CodePoint(): var

    Utf8CodePoint;

    /**
     * read Utf8ByteCount data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param byteCount: int byteCount to be written in integer
     * @return Utf8ByteCount data
     */
    function readUtf8ByteCount(byteCount): var

    string

    /**
     * write sub string of string.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param string: The string to be written in string
     * @param beginIndex: The beginIndex to be written in integer
     * @param endIndex: The endIndex to be written in integer
     * @return buffer data
     */
    function writeSubString(string, beginIndex, endIndex): Buffer

    /**
     * write Utf8 sub string of string.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param string: The string to be written in string
     * @param beginIndex: The beginIndex to be written in integer
     * @param endIndex: The endIndex to be written in integer
     * @return buffer data
     */
    function writeUtf8BeginEndIndex(string, beginIndex, endIndex): Buffer

    /**
     * write string.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param pos: int pos to be written in integer
     * @return string data
     */
    function getCommonResult(pos): string;

    /**
     * skip the bytes.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param bytecount: int bytecount to be written in integer
     */
    function skipByteCount(bytecount)

    /**
     * read byte array.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param byteCount: The bytecount to be written in integer
     * @return string data
     */
    function readByteArray(byteCount): string

    /**
     * read data by given length.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param sink: int sink to be written in integer
     * @return buffer data
     */
    function readFully(sink): Buffer

    /**
     * read data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param sink: The sink to be written in integer
     * @param offset: The offset to be written in integer
     * @param byteCount: The byteCount to be written in integer
     * @return data length
     */
    function read(sink, offset, byteCount): var

    int
}

export default Buffer;