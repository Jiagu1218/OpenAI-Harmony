import http from '@ohos.net.http'
import {OpenAIApi} from '@ohos/openai-harmony';

export class  CreateImageViewModel{
  private openai:OpenAIApi = OpenAIApi.getInstance({apiKey:''})

  async createImage(msg:string):Promise<Array<string>>{
      try{
        const response:http.HttpResponse = await this.openai.createImage({prompt:msg,n:9})
        const result = JSON.parse(response.result.toString())
        return result.data.map((item)=>{
          return item.url
        })
      }catch(e){
        console.info('openai', JSON.stringify(e));
        return []
      }
  }
}