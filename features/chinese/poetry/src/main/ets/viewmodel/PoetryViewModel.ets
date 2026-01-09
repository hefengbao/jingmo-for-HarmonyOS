import { addBookmark, Bookmark, cancelBookmark, getBookmark } from 'bookmark';
import { PrefConst } from 'constants';
import { YmdHisToNumber } from 'utils';
import { getBookmarks, getPoetry, getRandomPoetry, ModernPoetry, search } from '../model/ModernPoetry';

class PoetryViewModel {
  getBookmark(id: number): Promise<Bookmark | undefined> {
    return getBookmark(id, PrefConst.CHINESE_MODERNPOETRY)
  }

  addBookmark(id: number): Promise<Bookmark | undefined> {
    return addBookmark(new Bookmark(YmdHisToNumber(), id, PrefConst.CHINESE_MODERNPOETRY))
      .then(() => {
        return getBookmark(id, PrefConst.CHINESE_MODERNPOETRY)
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
    return cancelBookmark(id, PrefConst.CHINESE_MODERNPOETRY)
  }

  getRandomPoetry(): Promise<ModernPoetry | undefined> {
    return getRandomPoetry();
  }

  getPoetry(id: number): Promise<ModernPoetry | undefined> {
    return getPoetry(id);
  }

  getBookmarks(): Promise<ModernPoetry[]> {
    return getBookmarks();
  }

  search(query: string): Promise<ModernPoetry[]> {
    return search(query);
  }
}

export default new PoetryViewModel();