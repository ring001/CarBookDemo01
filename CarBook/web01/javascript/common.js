/**
 * Created by Administrator on 2016/6/24.
 */
var data = ["第一次自我介绍","第二次自我介绍","第三次自我介绍"];
var mySwiperFirst = new Swiper ('.first-container', {
        direction: 'horizontal',
        loop: false,

        // 如果需要前进后退按钮
        nextButton: '.swiper-button-next',
        prevButton: '.swiper-button-prev',
    onSlideChangeEnd: function(mySwiperFirst){
        console.log(mySwiperFirst.activeIndex);
         slideChangeEnd('slideChangeEnd',mySwiperFirst.activeIndex);
        }
    });
var mySwiperSecond = new Swiper ('.second-container', {
    direction: 'vertical',
    loop: false
});
var mySwiperThird = new Swiper ('.third-container', {
    direction: 'horizontal',
    loop: false,
    onSlideChangeEnd: function(mySwiperThird){
        $(".picthum ul li").removeClass("thum-select");
        $(".picthum ul li").eq(mySwiperThird.activeIndex).addClass("thum-select");
        $(".picthum p").html(data[mySwiperThird.activeIndex]);
    }
});
$(".picthum ul li").click(function () {
    var index = $(this).index();
    console.log(index);
    mySwiperThird.slideTo(index,1000);
    $(this).addClass("thum-select");
    $(this).siblings().removeClass("thum-select");
    $(".picthum p").html(data[index]);
});

$(".nav ul li").click(function () {
    var index = $(this).index();
    mySwiperFirst.slideTo(index,0);
});
$(".nav2 ul li").click(function () {
    var index = $(this).index();
    mySwiperFirst.slideTo(2,0);
    mySwiperSecond.slideTo(index,0);
});
$(".showeqv ul li").click(function () {
    $(".layer").css({"opacity":"1","z-index":"12"});
     
});

function closeContent(){
      $(".layer").css({"opacity":"0","z-index":"-12"});
}

$(".close").click(function () {
    $(".layer").css({"opacity":"0","z-index":"-12"});
 
});
$(".close-video").click(function () {
    player.pause();
    $(".show-video").hide();
});
$(".playVideo").click(function () {
   // $(".show-video").show();
   // player.play();
    iosPlayVideo();
});
var player = videojs('video');
player.on('timeupdate', function () {
    // 如果 currentTime() === duration()，则视频已播放完毕
    if (player.duration() != 0 && player.currentTime() === player.duration()) {
        // 播放结束
        $(".show-video").hide();
    }
});