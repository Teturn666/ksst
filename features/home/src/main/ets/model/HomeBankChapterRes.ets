import { ChapterInfoRes } from './ChapterInfoRes'

export interface HomeBankChapterRes {
  id: number
  name: String
  desc: String
  cover: String
  chapterList: ChapterInfoRes[]
}