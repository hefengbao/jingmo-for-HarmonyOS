import { addBookmark, Bookmark, cancelBookmark, getBookmark } from 'bookmark';
import { PrefConst } from 'constants';
import { YmdHisToNumber } from 'utils';
import { getLyric, getRandomLyric, Lyric, search } from '../model/Lyric';

class LyricViewModel {
  getBookmark(id: number): Promise<Bookmark | undefined> {
    return getBookmark(id, PrefConst.CHINESE_LYRIC)
  }

  addBookmark(id: number): Promise<Bookmark | undefined> {
    return addBookmark(new Bookmark(YmdHisToNumber(), id, PrefConst.CHINESE_LYRIC))
      .then(() => {
        return getBookmark(id, PrefConst.CHINESE_LYRIC)
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
    return cancelBookmark(id, PrefConst.CHINESE_LYRIC)
  }

  getRandomLyric(): Promise<Lyric | undefined> {
    return getRandomLyric()
  }

  getLyric(id: number): Promise<Lyric | undefined> {
    return getLyric(id);
  }

  search(query: string): Promise<Lyric[]>{
    return search(query);
  }
}

export default new LyricViewModel();