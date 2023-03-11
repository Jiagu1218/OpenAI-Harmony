import { ChatMessage } from './ChatMessage';
import { BasicDataSource } from './BasicDataSource';
/**
 * 实现 lazyforeach 懒加载 所需接口
 * */
export class ChatMessageList extends BasicDataSource{
  private list:Array<ChatMessage> = []
//    [
//    {role:'assistant',content:'aaaaa'},{role:'assistant',content:'aaaaa'},
//    {role:'user',content:'aaaaa\\n aas asdasdas'}
//  ]

  public totalCount(): number {
    return this.list.length
  }

  public getData(index: number): ChatMessage {
    return this.list[index]
  }

  public addData(index: number, data: ChatMessage): void {
    this.list.splice(index, 0, data)
    this.notifyDataAdd(index)
  }

  public pushData(data: ChatMessage): void {
    this.list.push(data)
    this.notifyDataAdd(this.list.length - 1)
  }

  public clearData(): void {
    this.list = []
    this.notifyDataReload()
  }

  public deleteData(index: number): void {
    this.list.splice(index, 1)
    this.notifyDataDelete(index)
  }

  public getList(){
    return this.list
  }

  /**
   * Fisher-Yates 洗牌算法（也称 Knuth 洗牌算法）是一种用于将数组随机排列的算法。该算法的原理比较简单：

   从数组的最后一项开始，向前遍历数组中的所有元素，直到第一个元素。
   对于每个元素，随机生成一个索引值，该索引值范围为 0 到当前元素的索引值。
   交换该元素和随机索引位置的元素。
   经过多次重复上述步骤，数组中的所有元素都将随机排列。

   该算法的时间复杂度为 O(n)，可以保证每个元素随机分布在数组中，并且每个元素在每个位置出现的概率相等。
   * */
  public shuffleArray():void {
    for (let i = this.list.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      //数组解构语法
      [this.list[i], this.list[j]] = [this.list[j], this.list[i]];
    }
    this.notifyDataReload()
  }


}