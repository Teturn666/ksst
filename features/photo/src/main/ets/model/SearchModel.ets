import { SearchEngine } from 'search/Index'
import { Logger } from 'utils/Index'
import { SearchResultNet } from '../service/SearchResultNet'
import { SearchResultRes } from './SearchResultRes'

const TAG = '[SearchModel]'

@Observed
export class SearchModel {
  private static instance: SearchModel
  private searchResultNet: SearchResultNet

  private constructor() {
    this.searchResultNet = new SearchResultNet()
  }

  public static getInstance(): SearchModel {
    if (!SearchModel.instance) {
      SearchModel.instance = new SearchModel()
    }
    return SearchModel.instance
  }

  public async searchResultList(word: string): Promise<SearchResultRes[]> {
    try {
      let data = await this.searchResultNet.getSearchResultList(word)
      return data
    } catch (e) {
      Logger.info(TAG, 'err--------' + e)
      return []
    }
  }
}