export function YmdHisToNumber(): number {
  const currentDate = new Date();

  // 使用 Date 对象的方法和属性获取当前日期和时间
  const year = currentDate.getFullYear();
  const month = currentDate.getMonth() + 1; // 注意月份从0开始，需要加1
  const day = currentDate.getDate();
  const hours = currentDate.getHours();
  const minutes = currentDate.getMinutes();
  const seconds = currentDate.getSeconds();

  return parseInt(`${year}${month}${day}${hours}${minutes}${seconds}`)
}