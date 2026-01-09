import { addBookmark, Bookmark, cancelBookmark, getBookmark } from 'bookmark';
import { PrefConst } from 'constants';
import { YmdHisToNumber } from 'utils';
import { getBookmarks, getProverb, getRandomProverb, Proverb, search } from '../model/Proverb';

class ProverbViewModel {
  getBookmark(id: number): Promise<Bookmark | undefined> {
    return getBookmark(id, PrefConst.CHINESE_PROVERB)
      .then((value: Bookmark | undefined) => {
        return value
      })
      .catch(() => {
        return undefined
      })
  }

  addBookmark(id: number): Promise<Bookmark | undefined> {
    return addBookmark(new Bookmark(YmdHisToNumber(), id, PrefConst.CHINESE_PROVERB))
      .then(() => {
        return getBookmark(id, PrefConst.CHINESE_PROVERB)
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
    return cancelBookmark(id, PrefConst.CHINESE_PROVERB)
  }

  getRandomProverb(): Promise<Proverb | undefined> {
    return getRandomProverb();
  }

  getProverb(id: number): Promise<Proverb | undefined> {
    return getProverb(id);
  }

  search(query: string): Promise<Proverb[]> {
    return search(query);
  }

  getBookmarks(): Promise<Proverb[]> {
    return getBookmarks();
  }
}

export default new ProverbViewModel();