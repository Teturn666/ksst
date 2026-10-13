# okio

## 简介

okio是一个通过数据流、序列化和文件系统来优化系统输入输出流的能力的库。它依托于系统能力，提供字符串的编解码转换能力，基础数据类型的读写能力以及支持对文件读写的能力。okio为数据容器提供缓冲区，并覆盖了NIO包所支持的特性功能。将okio作为httpclient的一个组件使它更容易访问、存储和处理数据。

## 下载安装

```javascript
ohpm install @ohos/okio 
```

## 使用说明:

```javascript
import okio from '@ohos/okio';
```

1. 在Buffer里写入和读取Utf8 ：

  ```javascript
   performWriteUtf8() {
       var buffer = new okio.Buffer();
       buffer.writeUtf8("test");
       var readUtfValue = buffer.readUtf8();
   }
  ```

2. 在Buffer里写入和读取Int：

  ```javascript
   performWriteInt() {
       var buffer = new okio.Buffer();
       buffer.writeInt(10);
       var readInt = buffer.readInt();
   }
  ```

3. 在Buffer里写入和读取String ：

  ```javascript
   performWriteString() {
       var buffer = new okio.Buffer();
       buffer.writeString("Test");
       var readString = buffer.readString();
   }
  ```

4. 在Buffer里写入和读取IntLe：

  ```javascript
   performWriteIntLe() {
       var buffer = new okio.Buffer();
       buffer.writeIntLe(25);
       var readIntLe = buffer.readIntLe();
   }
  ```

5. 在Buffer里写入和读取Short：

  ```javascript
   performWriteShort() {
       var buffer = new okio.Buffer();
       buffer.writeShort(25);
       var readShort = buffer.readShort();
   }
  ```

6. 在Buffer里写入和读取ShortLe：

  ```javascript
   performWriteShortLe() {
       var buffer = new okio.Buffer();
       buffer.writeShortLe(100);
       var readShortLe = buffer.readShortLe();
   }
  ```

7. 在Buffer里写入和读取Byte：

  ```javascript
   performWriteByte() {
       var buffer = new okio.Buffer();
       buffer.writeByte(9)
       var readByte = buffer.readByte();
   }
  ```

8. 在Buffer里写入和读取Utf8CodePoint ：

  ```javascript
   performWriteUtf8CodePoint() {
       var buffer = new okio.Buffer();
       buffer.writeUtf8CodePoint(99);
       var readUtf8CodePointValue = buffer.readUtf8CodePoint();
   }
  ```

9. 将Base64编码的字符串写入ByteString ：

  ```javascript
   decodeBase64() {
       let decodeBase64 = byteStringCompanObj.decodeBase64('SGVsbG8gd29ybGQ=');
       let decodeBase64Value = JSON.stringify(decodeBase64);
   }
  ```

10. 将十六进制字符串写入ByteString ：

    ```javascript
    decodeHex() {
        let decodehex = byteStringCompanObj.decodeHex('48656C6C6F20776F726C640D0A');
        let decodeHexValue = JSON.stringify(decodehex);
    }
    ```

11. 将Utf8格式的字符串写入ByteString ：

    ```javascript
    encodeUtf8() {
        let encodeUtf8 = byteStringCompanObj.encodeUtf8('Hello world #4 ❤ ( ͡ㆆ ͜ʖ ͡ㆆ)');
        let encodeUtf8Value = JSON.stringify(encodeUtf8);
    }
    ```

12. 将字符串写入ByteString ：

    ```javascript
    ofValue() {
        let ofData = byteStringCompanObj.of(["Hello", "world"]);
        let ofOutputValue = JSON.stringify(ofData);
    }
    ```

13. 将内容写入文件 ：

     ```javascript
    writeFile() {
        let fileUri = '/data/data/com.openharmony.ohos.okioapplication/cache/test.txt';
        let writeInputValue = "openharmony";
        var sink = new okio.Sink(fileUri);
        var isAppend = false;
    	sink.write(writeInputValue,isAppend);
    }
     ```

14. 读取文件内容：

    ```javascript
    readFileValue() {
        let fileUri = '/data/data/com.openharmony.ohos.okioapplication/cache/test.txt';
        var source = new okio.Source(fileUri);
        source.read().then(function (data) {
            that.readValue = data;
        }).catch(function (error) {
            //Error
        });
    }
    ```

## 接口说明

### Buffer

| 接口名                 | 参数                         | 返回值        | 说明                                                |
| ---------------------- | ---------------------------- | ------------- | --------------------------------------------------- |
| writeUtf8              | data: string                 | Buffer        | 在Buffer中写入Utf8类型的数据                        |
| readUtf8               | 无                           | string        | 从Buffer中读取字符串                                |
| writeInt               | data: int                    | Buffer        | 在Buffer中写入Int类型数据                           |
| readInt                | 无                           | int           | 从Buffer中读取Int类型数据                           |
| writeString            | data: string                 | Buffer        | 在Buffer中写入字符串类型的数据                      |
| readString             | 无                           | string        | 从Buffer中读取字符串                                |
| writeIntLe             | data: intLe                  | Buffer        | 在Buffer中写入IntLe类型数据                         |
| readIntLe              | 无                           | intLe         | 从Buffer中读取IntLe类型数据                         |
| writeShortLe           | data: shortLe                | Buffer        | 在Buffer中写入ShortLe类型数据                       |
| readShortLe            | 无                           | shortLe       | 从Buffer中读取ShortLe类型数据                       |
| writeShort             | data: Short                  | Buffer        | 在Buffer中写入Short类型数据                         |
| readShort              | 无                           | short         | 从Buffer中读取Short类型数据                         |
| writeByte              | data: byte                   | Buffer        | 在Buffer中写入Byte类型数据                          |
| readByte               | 无                           | byte          | 从Buffer中读取Byte类型数据                          |
| writeUtf8CodePoint     | data: Utf8CodePoint          | Buffer        | 在Buffer中写入Utf8CodePoint                         |
| readUtf8CodePoint      | 无                           | Utf8CodePoint | 从Buffer中读取Utf8CodePoint                         |
| readUtf8ByteCount      | byteCount                    | string        | 从Buffer中返读取长度为byteCount的字符串数据并返回   |
| writableSegment        | minimumCapacity              | int           | 根据写入的数据长度获取可用于写入的Segment           |
| writeSubString         | string, beginIndex, endIndex | Buffer        | 在Buffer中写入传入的字符串的子字符串并返回该Buffer  |
| writeUtf8BeginEndIndex | string, beginIndex, endIndex | Buffer        | 在Buffer中写入传入的字符串的子字符串并返回该Buffer  |
| getCommonResult        | pos: int                     | string        | 在Buffer中读取pos长度的数据并以string类型返回       |
| skipByteCount          | bytecount: int               | void          | 跳过bytecount从Buffer中读取数据                     |
| readByteArray          | byteCount                    | string        | 从Buffer中读取byteCount长度的数据并以字符串形式返回 |
| readFully              | sink: int                    | Buffer        | 按照给定的长度读取数据并返回Buffer                  |
| read                   | sink, offset,                | int           | 从offset开始读取byteCount的数据                     |

### ByteString

| 接口名           | 参数               | 返回值     | 说明                                                         |
| ---------------- | ------------------ | ---------- | ------------------------------------------------------------ |
| ByteString       | data: buffer       | void       | 获取数据缓冲区并创建ByteString示实例                         |
| decodeBase64     | data: Base64String | ByteString | 对输入的Base64编码的数据进行解码，并将结果以ByteString的形式返回 |
| decodeHex        | data: HexString    | ByteString | 对输入的十六进制数据进行解码，并将结果以ByteString的形式返回 |
| encodeUtf8       | data: string       | ByteString | 对输入的字符串进行UTF-8编码，并将结果以ByteString的形式返回  |
| of               | data: array        | ByteString | 返回一个复制了参数data的数据的新ByteString                   |
| toAsciiLowercase | data: string       | ByteString | 将输入的字符串转换为小写形式，并将结果以ByteString的形式返回 |
| toAsciiUppercase | data: string       | ByteString | 将输入的字符串转换为大写形式，并将结果以ByteString的形式返回 |
| toByteArray      | 无                 | ByteArray  | 将ByteString中字节数组复制后以ByteArray形式返回              |
| getWithIndex     | index: int         | ByteValue  | 以整数作为输入并返回 ByteValue                               |
| getSize          | 无                 | DataLength | 返回ByteString中的字节数                                     |
| internalArray    | 无                 | ByteArray  | 返回ByteString中的原始字节，而不是复制的数据                 |
| hashCode         | 无                 | Hashcode   | 返回ByteString的哈希吗值                                     |
| compareToOther   | other: Buffer      | ByteArray  | 用于比较两个ByteString并返回：<br/>(a) 如果ByteString的大小相同，字符串相等，则返回0；<br/>(b) 如果原始ByteString的第一个字符小于比较ByteString的第一个字符，则返回-1；<br/>(c)如果原始ByteString的第一个字符大于比较ByteString的第一个字符，则返回1；<br/> |

### FIleHandler(Sink, Source)

| 接口名 | 参数                                       | 返回值 | 说明                                                         |
| ------ | ------------------------------------------ | ------ | ------------------------------------------------------------ |
| read   | 无                                         | string | 从文件中读取内容并返回                                       |
| write  | writeInputValue: string, isAppend: boolean | void   | 如果 isAppend 设置为 false，则将字符串值写入新文件；如果 isAppend 设置为 true，则附加更新到现有文件 |

## 约束与限制

在下述版本验证通过：

- DevEco Studio: NEXT Beta1-5.0.3.806, SDK:API12 Release(5.0.0.66)
- Deveco Studio:4.0 (4.0.3.512),SDK:API10 (4.0.10.9)

## 目录结构

````javascript
|---- okio  
|     |---- entry  # 示例代码文件夹
|     |---- library  # okio 库文件夹
|           |---- index.ets  # okio对外接口
|     |---- README.MD  # 安装使用方法                   
````

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitee.com/openharmony-tpc/okio/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitee.com/openharmony-tpc/okio/pulls)。

## 开源协议

本项目基于 [Apache License 2.0](https://gitee.com/openharmony-tpc/okio/blob/master/LICENSE)，请自由地享受和参与开源。
