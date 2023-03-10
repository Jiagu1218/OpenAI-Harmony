import { CreateEmbeddingRequest } from './CreateEmbeddingRequest';
import { CreateModerationRequest } from './CreateModerationRequest';
import { CreateFineTuneRequest } from './CreateFineTuneRequest';
import { CreateCompletionRequest } from './CreateCompletionRequest';
import { CreateImageRequest } from './CreateImageRequest';
import { CreateChatCompletionRequest } from './CreateChatCompletionRequest';
import { Constant } from './Constant';

import http from '@ohos.net.http'
import request from '@ohos.request'

export interface Configuration{
  apiKey: string
}

/**
 * 表单数据
 * */
export interface RequestData{
  name: string;
  value: string;
}

export interface File{
  filename:string
  uri:string
}

const METHOD_POST = http.RequestMethod.POST
const METHOD_GET = http.RequestMethod.GET
const METHOD_DELETE = http.RequestMethod.DELETE

/**
 * api相关说明参数说明 https://platform.openai.com/docs/api-reference/authentication
 * */
export class OpenAIApi{
  private static readonly TAG = "OpenAIApi"
  private static instance: OpenAIApi | null = null
  private configuration:Configuration | null = null
  private header:{ [key: string]: string }

  private constructor(config:Configuration) {
    this.configuration = config
    this.header = {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${config.apiKey}`
    }
  }

  public static getInstance(config?: Configuration):OpenAIApi{
    if (!OpenAIApi.instance || config != null ){
      OpenAIApi.instance = new OpenAIApi(config as Configuration)
    }
    return OpenAIApi.instance
  }

  public static updateConfig(config: Configuration){
    const instance = OpenAIApi.getInstance(config);
    if(instance){
      instance.configuration = config;
      instance.header.Authorization = `Bearer ${config.apiKey}`;
    }
  }

  private createRequest(url:string,method:http.RequestMethod=METHOD_GET,body?:any,header?:object):Promise<http.HttpResponse>{
    return http.createHttp().request(url,{
      method: method,
      header:header??this.header,
      extraData:body
    })
  }

  private createUploadRequest(url:string,files:Array<request.File>,formData?:request.RequestData[]):Promise<request.UploadTask>{
    const uploadConfig:request.UploadConfig = {
      url: url,
      header: {
        'Content-Type': 'multipart/form-data',
        'Authorization': `Bearer ${this.configuration.apiKey}`,
      },
      method: METHOD_POST,
      files: files,
      data: formData?formData:undefined
    }
    try {
      return request.uploadFile(globalThis.abilityContext, uploadConfig)
    } catch (error) {
      console.error(OpenAIApi.TAG,JSON.stringify(error));
      throw error;
    }
  }

  /*
   * https://platform.openai.com/docs/api-reference/chat/create
   * */
  createChatCompletion(completionRequest:CreateChatCompletionRequest):Promise<http.HttpResponse>{
    return this.createRequest(Constant.URL_CHAT_COMPLETION,METHOD_POST,completionRequest)
  }

  createCompletion(createCompletionRequest:CreateCompletionRequest):Promise<http.HttpResponse>{
    return this.createRequest(Constant.URL_COMPLETIONS,METHOD_POST,createCompletionRequest)
  }

  createFineTune(createFineTuneRequest: CreateFineTuneRequest):Promise<http.HttpResponse>{
    return this.createRequest(Constant.URL_FINE_TUNE,METHOD_POST,createFineTuneRequest)
  }
  listFineTunes():Promise<http.HttpResponse>{
    return this.createRequest(Constant.URL_FINE_TUNE)
  }
  listFineTuneEvents(fineTuneId:string):Promise<http.HttpResponse>{
    return this.createRequest(`${Constant.URL_FINE_TUNE}/${fineTuneId}/${Constant.LIST_FINE_TUNE_EVENTS}`)
  }
  retrieveFineTune(fineTuneId:string):Promise<http.HttpResponse>{
    return this.createRequest(`${Constant.URL_FINE_TUNE}/${fineTuneId}`)
  }

  createImage(creationRequest:CreateImageRequest):Promise<http.HttpResponse>{
    return this.createRequest(Constant.URL_CREATE_IMAGE,METHOD_POST,creationRequest)
  }

  createEmbedding(createEmbeddingRequest: CreateEmbeddingRequest):Promise<http.HttpResponse>{
    return this.createRequest(Constant.URL_CREATE_EMBEDDINGS,METHOD_POST,createEmbeddingRequest)
  }

  /**
   * https://platform.openai.com/docs/api-reference/images/create-edit?lang=node.js
   * */
  createImageEdit(image: File, prompt: string, mask?: File, n?: number, size?: string, responseFormat?: string, user?: string):Promise<request.UploadTask>{
    let files = [{ filename: image.filename, name: "image", uri: image.uri, type: "png" }]
    let formData:Array<RequestData> = [{name:'prompt',value:prompt}]
    mask?files.push({ filename: mask.filename, name: "image", uri: mask.uri, type: "png" }):undefined
    n?formData.push({name:'n',value:`${n}`}):undefined
    size?formData.push({name:'size',value:size}):undefined
    responseFormat?formData.push({name:'responseFormat',value:responseFormat}):undefined
    user?formData.push({name:'user',value:user}):undefined
    return this.createUploadRequest(Constant.URL_CREATE_IMAGE_EDIT,files,formData)
  }

  createImageVariation(image: File, n?: number, size?: string, responseFormat?: string, user?: string):Promise<request.UploadTask>{
    let files = [{ filename: image.filename, name: "image", uri: image.uri, type: "png" }]
    let formData:Array<RequestData> = []
    n?formData.push({name:'n',value:`${n}`}):undefined
    size?formData.push({name:'size',value:size}):undefined
    responseFormat?formData.push({name:'responseFormat',value:responseFormat}):undefined
    user?formData.push({name:'user',value:user}):undefined
    return this.createUploadRequest(Constant.URL_CREATE_IMAGE_VARIATION,files,formData)
  }

  createTranscription(file: File, model: string, prompt?: string, responseFormat?: string, temperature?: number, language?: string):Promise<request.UploadTask>{
    let files = [{ filename: file.filename, name: "file", uri: file.uri, type: file.filename.substring(file.filename.lastIndexOf('.')+1) }]
    let formData:Array<RequestData> = [{name:'model',value:model}]
    prompt?formData.push({name:'prompt',value:prompt}):undefined
    responseFormat?formData.push({name:'responseFormat',value:responseFormat}):undefined
    temperature?formData.push({name:'temperature',value:`${temperature}`}):undefined
    prompt?formData.push({name:'language',value:language}):undefined
    return this.createUploadRequest(Constant.URL_CREATE_TRANSCRIPTION,files,formData)
  }

  createTranslation(file: File, model: string, prompt?: string, responseFormat?: string, temperature?: number):Promise<request.UploadTask>{
    let files = [{ filename: file.filename, name: "file", uri: file.uri, type: file.filename.substring(file.filename.lastIndexOf('.')+1) }]
    let formData:Array<RequestData> = [{name:'model',value:model}]
      prompt?formData.push({name:'prompt',value:prompt}):undefined
      responseFormat?formData.push({name:'responseFormat',value:responseFormat}):undefined
      temperature?formData.push({name:'temperature',value:`${temperature}`}):undefined
    return this.createUploadRequest(Constant.URL_CREATE_TRANSLATION,files,formData)
  }

  listModels():Promise<http.HttpResponse>{
    return this.createRequest(Constant.URL_LIST_MODELS)
  }
  deleteModel(model: string){
    return this.createRequest(`${Constant.URL_LIST_MODELS}/${model}`,METHOD_DELETE)
  }

  retrieveModel(model:string):Promise<http.HttpResponse>{
    return this.createRequest(`${Constant.URL_LIST_MODELS}/${model}`)
  }

  listFiles():Promise<http.HttpResponse>{
    return this.createRequest(Constant.URL_LIST_FILES)
  }

  createFile(file: File, purpose: string):Promise<request.UploadTask>{
    let files = [{ filename: file.filename, name: "file", uri: file.uri, type: file.filename.substring(file.filename.lastIndexOf('.')+1) }]
    let formData:Array<RequestData> = [{name:'purpose',value:purpose}]
    return this.createUploadRequest(Constant.URL_LIST_FILES,files,formData)
  }

  deleteFile(fileId: string):Promise<http.HttpResponse>{
    return this.createRequest(`${Constant.URL_LIST_FILES}/${fileId}`,METHOD_DELETE)
  }
  retrieveFile(fileId: string):Promise<http.HttpResponse>{
    return this.createRequest(`${Constant.URL_LIST_FILES}/${fileId}`)
  }

  downloadFile(fileId: string):Promise<request.DownloadTask>{
    try{
      return request.downloadFile(getContext(this),{
        url:`${Constant.URL_LIST_FILES}/${fileId}/content`,
        enableMetered:true,
        background:true,
        header:{
          'Authorization':`Bearer ${this.configuration.apiKey}`
        }
      })
    }catch(error){
      console.error(OpenAIApi.TAG,JSON.stringify(error));
      throw error
    }
  }

  createModeration(createModerationRequest: CreateModerationRequest):Promise<http.HttpResponse>{
    return this.createRequest(Constant.URL_CREATE_MODERATION,METHOD_POST,createModerationRequest)
  }
}

