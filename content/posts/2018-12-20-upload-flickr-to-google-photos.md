---
title: 將 Flickr 相簿備份到 Google Photos
author: appleboy
type: post
date: 2018-12-20T02:43:29+00:00
url: /2018/12/upload-flickr-to-google-photos/
dsq_thread_id:
  - 7115717740
categories:
  - Golang

---
[![][1]][2] [Flickr][3] 在 [2019 年一月][4]會開始將免費會員照片刪除到剩下 1000 張，這次透過 [Go 工具][5] 來將備份好的 Flickr 相簿上傳到 Google Photos，此工具只適合用在 MacOS 及 Linux 上面，Windows 請改用『[Backup and Sync from Google][6]』工具。

> *Free members with more than 1,000 photos or videos uploaded to Flickr have until Tuesday, January 8, 2019, to upgrade to Pro or download content over the limit. After January 8, 2019, members over the limit will no longer be able to upload new photos to Flickr. After February 5, 2019, free accounts that contain over 1,000 photos or videos will have content actively deleted -- starting from oldest to newest date uploaded -- to meet the new limit.

## 影片介紹

底下影片會帶大家一步一步將 Flickr 檔案備份到 [Google Photos][7] 服務上。

 [1]: https://lh3.googleusercontent.com/D7QDeQ5CKOgRnQoFLn0_uuZ8sYyjsf7o2HedEWYnLYKLx0yUBhNL6FGRQD9UXyzENIpWqUpJPWvzeGxUr1WHi8LA6CJIUYsBF1JlnajNfHSTD6oI-jWthUL9F6ZdmJIEi_09adlnkSU=w2400
 [2]: https://photos.google.com/share/AF1QipP_QY5xz1ceXLg1xyyNs8gWwwctMGS6gAOHecmEYudxrN1sUuk9dVUmyQextiCCEQ?key=VzE2bnhza1g0ZWhPeGZfZHFvYmVFMkEtYmQxSk1R&source=ctrlq.org
 [3]: https://www.flickr.com
 [4]: https://www.flickr.com/lookingahead/
 [5]: https://github.com/nmrshll/gphotos-uploader-cli
 [6]: https://www.playpcesor.com/2017/07/google-Backup-and-Sync-photos.html
 [7]: https://photos.google.com