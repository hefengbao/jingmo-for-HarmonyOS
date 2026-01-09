import { addBookmark, Bookmark, cancelBookmark, getBookmark } from 'bookmark';
import { PrefConst } from 'constants';
import { YmdHisToNumber } from 'utils';
import { getBookmarks, getWriting, Writing } from '../model/Writing';

class WritingViewModel {
  getBookmark(id: number): Promise<Bookmark | undefined> {
    return getBookmark(id, PrefConst.CLASSICALLITERATURE_WRITING)
      .then((value: Bookmark | undefined) => {
        return value
      })
      .catch(() => {
        return undefined
      })
  }

  addBookmark(id: number): Promise<Bookmark | undefined> {
    return addBookmark(new Bookmark(YmdHisToNumber(), id, PrefConst.CLASSICALLITERATURE_WRITING))
      .then(() => {
        return getBookmark(id, PrefConst.CLASSICALLITERATURE_WRITING)
          .then((value: Bookmark | undefined) => {
            return value
          })
          .catch(() => {
            return undefined
          })
      })
      .catch(() => {
        return undefined
      })
  }

  cancelBookmark(id: number): Promise<number | undefined> {
    return cancelBookmark(id, PrefConst.CLASSICALLITERATURE_WRITING)
  }

  getWriting(id: number): Promise<Writing | undefined> {
    return getWriting(id);
  }

  getBookmarks(): Promise<Writing[]> {
    return getBookmarks();
  }

  /*search(query: string): Promise<Writing[]> {
    return search(query);
  }*/
}

export default new WritingViewModel();