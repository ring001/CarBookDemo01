/**
 * Created by Administrator on 2016/6/24.
 */
var mySwiperFirst = new Swiper ('.first-container', {
                                direction: 'horizontal',
                                loop: false,
                                
                                // 如果需要前进后退按钮
                                nextButton: '.swiper-button-next',
                                prevButton: '.swiper-button-prev',
                                onSlideChangeEnd: function(mySwiperFirst){
                                //console.log(mySwiperFirst.activeIndex);
                                //mySwiperFirst.activeIndex
                                  slideChangeEnd('slideChangeEnd',mySwiperFirst.activeIndex);
                                }
                                
                                });
var mySwiperSecond = new Swiper ('.second-container', {
    direction: 'vertical',
    loop: false
});

function JSCallOc1(){
    
    test1();
}
function JSCallOc2(){
    test2('少停','iOS');
}

$(".nav ul li").click(function () {
    test1();
                 //     alert("test111");
    var index = $(this).index();
    mySwiperFirst.slideTo(index,0);

});
$(".nav2 ul li").click(function () {
    test2('少停','iOS');
                      // alert("test222");
    var index = $(this).index();
    mySwiperFirst.slideTo(2,0);
    mySwiperSecond.slideTo(index,0);
 
});

function aaa(){
    alert("OC调用了无参数的js方法");
}
function bbb(name,num){
    alert(name+num);
}
