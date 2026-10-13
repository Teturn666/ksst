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
 * the ByteString Object
 * @name ByteString
 * @since 1.0.0
 * @sysCap AAFwk
 * @devices phone, tablet
 * @permission N/A
 */
declare namespace ByteString {

/**
 * Create ByteString instance.
 *
 * @devices phone, tablet
 * @since 1.0.0
 * @sysCap AAFwk
 * @param data: String data to be stored in Buffer
 */
    function ByteString(data: buffer);

    /**
     * write Base64String data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param data: The data to be decode
     * @return - ByteString
     */
    function decodeBase64(data: Base64String): ByteString;

    /**
     * write HexString data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param data: The data to be decode
     * @return - ByteString
     */
    function decodeHex(data: HexString): ByteString;

    /**
     * write string data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param data: The data to be decode
     * @return - ByteString
     */
    function encodeUtf8(data: string): ByteString;

    /**
     * write array data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param data: array data
     * @return - ByteString
     */
    function of(data: array): ByteString;

    /**
     * write string data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param data: The data to be string
     * @return - ByteString
     */
    function toAsciiLowercase(data: string): ByteString;

    /**
     * write string data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param data: The data to be string
     * @return - ByteString
     */
    function toAsciiUppercase(data: string): ByteString;

    /**
     * Return ByteString data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @return - ByteString
     */
    function toByteArray(): ByteString;

    /**
     * write int data.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param index: The index to be integer
     * @return - ByteValue
     */
    function getWithIndex(index: int): ByteValue;

    /**
     * Return data size.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @return - DataLength
     */
    function getSize(): var

    DataLength;

    /**
     * Return byte array.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @return - ByteArray
     */
    function internalArray(): ByteArray;

    /**
     * Return hash code.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @return - Hashcode
     */
    function hashCode(): Hashcode

    /**
     * write byte array.
     *
     * @devices phone, tablet
     * @since 1.0.0
     * @sysCap AAFwk
     * @param other: The other to be buffer.
     * @return - ByteValue
     */
    function compareToOther(other: Buffer): ByteArray
}

export default ByteString;