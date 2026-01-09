import { addBookmark, Bookmark, cancelBookmark, getBookmark } from 'bookmark';
import { PrefConst } from 'constants';
import { YmdHisToNumber } from 'utils';
import { getBookmarks, getRandomWisecrack, getWisecrack, search, Wisecrack } from '../model/Wisecrack';

class WisecrackViewModel {
  getBookmark(id: number): Promise<Bookmark | undefined> {
    return getBookmark(id, PrefConst.CHINESE_WISECRACK)
      .then((value: Bookmark | undefined) => {
        return value
      })
      .catch(() => {
        return undefined
      })
  }

  addBookmark(id: number): Promise<Bookmark | undefined> {
    return addBookmark(new Bookmark(YmdHisToNumber(), id, PrefConst.CHINESE_WISECRACK))
      .then(() => {
        return getBookmark(id, PrefConst.CHINESE_WISECRACK)
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
    return cancelBookmark(id, PrefConst.CHINESE_WISECRACK)
  }

  getRandomWisecrack(): Promise<Wisecrack | undefined> {
    return getRandomWisecrack();
  }

  getWisecrack(id: number): Promise<Wisecrack | undefined> {
    return getWisecrack(id);
  }

  search(query: string): Promise<Wisecrack[]> {
    return search(query);
  }

  getBookmarks(): Promise<Wisecrack[]> {
    return getBookmarks();
  }
}

export default new WisecrackViewModel();