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
 * the Sink Object
 * @name Sink
 * @since 1.0.0
 * @sysCap AAFwk
 * @devices phone, tablet
 * @permission N/A
 */
declare namespace Sink {

/**
 * Write content onto file.
 *
 * @devices phone, tablet
 * @since 1.0.0
 * @sysCap AAFwk
 * @param data: file path
 */
    function write(data: string, isAppend: boolean);
}

export default Sink;