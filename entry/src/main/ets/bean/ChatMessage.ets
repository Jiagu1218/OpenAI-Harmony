export declare enum Role {
  system='system',
  assistant='assistant',
  user='user'
}
export interface ChatMessage{
  id:number
  role:Role|string
  content:string
}