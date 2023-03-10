##### 简介
基于@ohos.request(文件上传下载) 和 @ohos.net.http(普通请求)
参考OPENAI 官方nodejs sdk和官方文档 针对鸿蒙系统进行的简单封装

##### 运行环境

    harmony sdk 3.2.2.2
    API>=9
    DevEco Studio 3.1 Beta1

##### 编译

打开项目 =》 build =》 make module 'OpenAI-Harmony'

##### 引用

[引用HarmonyOS npm包文件和资源](https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/creating_har_api8-0000001341502357-V3?catalogVersion=V3#section89674298391)

##### 使用说明
```typescript
//引用
import {OpenAIApi} from '@ohos/openai-harmony';

//初始化
this.openai = OpenAIApi.getInstance({apiKey:'openai ke'})
//创建对话
this.openai.createChatCompletion({
  model: "gpt-3.5-turbo",
  messages: [{role: "user", content: "Hello world"}],
}).then(result=>{
  //处理返回结果
  console.info('openai',JSON.stringify(result))
}).catch(error=>{
  //处理异常
  console.error('openai',JSON.stringify(error))
})
``` 


    