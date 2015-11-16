//
//  Urls.h
//  Radio
//
//  Created by 雨爱阳 on 15/10/21.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#ifndef Radio_Urls_h
#define Radio_Urls_h

//精选
#define kFeatureUrls @"http://api.kaolafm.com/api/v4/pagecontent/list?pageid=6&installid=0000zPXT&udid=6fb609b09a9a9c0f8b5ea15a7fb30b7c&sessionid=6fb609b09a9a9c0f8b5ea15a7fb30b7c1445340608996&imsi=460006482175750&operator=1&network=1&timestamp=1445340820&sign=b369bb4f989164e84387694ffb5d0673&resolution=480*854&devicetype=0&channel=A-360&version=4.2.2&appid=0"

//全部的顶部滚动条的网址
#define kHeaderAllUrls @"http://api.kaolafm.com/api/v4/category/list?fid=255&installid=0000zPXT&udid=6fb609b09a9a9c0f8b5ea15a7fb30b7c&sessionid=6fb609b09a9a9c0f8b5ea15a7fb30b7c1445340608996&imsi=460006482175750&operator=1&network=1&timestamp=1445340820&sign=b369bb4f989164e84387694ffb5d0673&resolution=480*854&devicetype=0&channel=A-360&version=4.2.2&appid=0"

//音乐全部下面cel
#define kMusicAllUrls(ID) [NSString stringWithFormat:@"http://api.kaolafm.com/api/v4/resource/search?words=&cid=%ld&sorttype=HOT_RANK_DESC&pagesize=10&pagenum=1&rtype=20000&installid=0000zPXT&udid=6fb609b09a9a9c0f8b5ea15a7fb30b7c&sessionid=6fb609b09a9a9c0f8b5ea15a7fb30b7c1445340608996&imsi=460006482175750&operator=1&network=1&timestamp=1445340821&sign=b369bb4f989164e84387694ffb5d0673&resolution=480*854&devicetype=0&channel=A-360&version=4.2.2&appid=0",ID]

//直播页面

//#define kLiveCommonalityUrls @"http://api.kaolafm.com/api/v4/liveprogram/list?pagenum=1&pagesize=20&type=0&installid=0000zPzE&udid=13b192fb86b461ef2b8395f19a4077db&sessionid=13b192fb86b461ef2b8395f19a4077db1445301302106&imsi=460019091504654&operator=2&network=1&timestamp=1445301904&playid=41056ec3c9160036e36f4d677364608f&sign=b236e0daf60f2ddd9bc34ac0ffc80686&resolution=720*1280&devicetype=0&channel=A-360&version=4.2.2&appid=0"
#define kLiveCommonalityUrls(number) [NSString stringWithFormat:@"http://api.kaolafm.com/api/v4/liveprogram/list?pagenum=%ld&pagesize=20&type=0&installid=0000zPzE&udid=13b192fb86b461ef2b8395f19a4077db&sessionid=13b192fb86b461ef2b8395f19a4077db1445301302106&imsi=460019091504654&operator=2&network=1&timestamp=1445301904&playid=41056ec3c9160036e36f4d677364608f&sign=b236e0daf60f2ddd9bc34ac0ffc80686&resolution=720*1280&devicetype=0&channel=A-360&version=4.2.2&appid=0",number]


//私人直播

#define kPrivateUrls @"http://api.kaolafm.com/api/v4/liveprogram/list?pagenum=1&pagesize=20&type=1&installid=0000zPXT&udid=6fb609b09a9a9c0f8b5ea15a7fb30b7c&sessionid=6fb609b09a9a9c0f8b5ea15a7fb30b7c1445340608996&imsi=460006482175750&operator=1&network=1&timestamp=1445340636&sign=b369bb4f989164e84387694ffb5d0673&resolution=480*854&devicetype=0&channel=A-360&version=4.2.2&appid=0"

//直播detail


//http://api.kaolafm.com/api/v4/liveprogramdetail/get?programid=1581812931&installid=0000zPzE&udid=13b192fb86b461ef2b8395f19a4077db&sessionid=13b192fb86b461ef2b8395f19a4077db1445301302106&imsi=460019091504654&operator=2&network=1&timestamp=1445301961&playid=41056ec3c9160036e36f4d677364608f&sign=b236e0daf60f2ddd9bc34ac0ffc80686&resolution=720*1280&devicetype=0&channel=A-360&version=4.2.2&appid=0
//

#define kPersonalStation @"http://fm.duole.com/api/rank/show_hot_user?limit=20&page=1&user_id=179793"


#define kListenBookList @"http://api.duotin.com/category/subcategories?device_key=358142035203999&platform=android&source=danxinben&device_token=Aj4I14X3yqA-jQTmYzKcK8ehebEIv3QLxMjC0uH1SnGu&user_key=&package=com.duotin.fm&category_id=323&channel=m360&version=2.7.12"

#define kListenBookAll @"http://api.duotin.com/category/content?page_size=20&device_key=358142035203999&platform=android&source=danxinben&page=1&device_token=Aj4I14X3yqA-jQTmYzKcK8ehebEIv3QLxMjC0uH1SnGu&user_key=&sub_category_id=-1&sort_type=2&package=com.duotin.fm&category_id=323&channel=m360&version=2.7.12"

#define kStationMisuicList @"http://fm.duole.com/api/sound/get_user_sound_list?visitor_uid=179793&device=android&page=1&limit=20&user_id=145712"


// 点击音乐进入播放
#define kPlayMusic @"http://api.kaolafm.com/api/v4/audios/list?id=1100000043055&sorttype=1&pagesize=20&pagenum=1&installid=0000zPXT&udid=6fb609b09a9a9c0f8b5ea15a7fb30b7c&sessionid=6fb609b09a9a9c0f8b5ea15a7fb30b7c1445435232269&imsi=460006482175750&operator=1&network=1&timestamp=1445437713&playid=a8f3914bfe028b436640b18d3c1d86ab&sign=b369bb4f989164e84387694ffb5d0673&resolution=480*854&devicetype=0&channel=A-360&version=4.2.2&appid=0"


#endif
