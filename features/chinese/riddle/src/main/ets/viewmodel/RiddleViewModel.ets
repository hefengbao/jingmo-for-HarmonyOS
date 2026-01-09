import { addBookmark, Bookmark, cancelBookmark, getBookmark } from 'bookmark';
import { PrefConst } from 'constants';
import { YmdHisToNumber } from 'utils';
import { getBookmarks, getRandomRiddle, getRiddle, Riddle, search } from '../model/Riddle';

class RiddleViewModel {
  getBookmark(id: number): Promise<Bookmark | undefined> {
    return getBookmark(id, PrefConst.CHINESE_RIDDLE)
      .then((value: Bookmark | undefined) => {
        return value
      })
      .catch(() => {
        return undefined
      })
  }

  addBookmark(id: number): Promise<Bookmark | undefined> {
    return addBookmark(new Bookmark(YmdHisToNumber(), id, PrefConst.CHINESE_RIDDLE))
      .then(() => {
        return getBookmark(id, PrefConst.CHINESE_RIDDLE)
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
    return cancelBookmark(id, PrefConst.CHINESE_RIDDLE)
  }

  getRandomRiddle(): Promise<Riddle | undefined> {
    return getRandomRiddle();
  }

  getRiddle(id: number): Promise<Riddle | undefined> {
    return getRiddle(id);
  }

  search(query: string): Promise<Riddle[]> {
    return search(query);
  }

  getBookmarks(): Promise<Riddle[]> {
    return getBookmarks();
  }
}

export default new RiddleViewModel();