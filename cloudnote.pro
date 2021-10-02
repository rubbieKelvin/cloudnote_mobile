QT += quick network quickcontrols2 svg core qml
CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

unix:android{
QT += androidextras
}

include(lib/qtstatusbar/src/statusbar.pri)

SOURCES += \
        main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

android: include(/home/rubbiekelvin/Android/Sdk/android_openssl/openssl.pri)

DISTFILES += \
	android/AndroidManifest.xml \
	android/build.gradle \
	android/gradle.properties \
	android/gradle/wrapper/gradle-wrapper.jar \
	android/gradle/wrapper/gradle-wrapper.properties \
	android/gradlew \
	android/gradlew.bat \
	android/res/values/libs.xml \
	uix/assets/fonts/Poppins/OFL.txt \
	uix/assets/fonts/Poppins/Poppins-Black.ttf \
	uix/assets/fonts/Poppins/Poppins-BlackItalic.ttf \
	uix/assets/fonts/Poppins/Poppins-Bold.ttf \
	uix/assets/fonts/Poppins/Poppins-BoldItalic.ttf \
	uix/assets/fonts/Poppins/Poppins-ExtraBold.ttf \
	uix/assets/fonts/Poppins/Poppins-ExtraBoldItalic.ttf \
	uix/assets/fonts/Poppins/Poppins-ExtraLight.ttf \
	uix/assets/fonts/Poppins/Poppins-ExtraLightItalic.ttf \
	uix/assets/fonts/Poppins/Poppins-Italic.ttf \
	uix/assets/fonts/Poppins/Poppins-Light.ttf \
	uix/assets/fonts/Poppins/Poppins-LightItalic.ttf \
	uix/assets/fonts/Poppins/Poppins-Medium.ttf \
	uix/assets/fonts/Poppins/Poppins-MediumItalic.ttf \
	uix/assets/fonts/Poppins/Poppins-Regular.ttf \
	uix/assets/fonts/Poppins/Poppins-SemiBold.ttf \
	uix/assets/fonts/Poppins/Poppins-SemiBoldItalic.ttf \
	uix/assets/fonts/Poppins/Poppins-Thin.ttf \
	uix/assets/fonts/Poppins/Poppins-ThinItalic.ttf \
	uix/assets/icons/coolicons/arrow/caret_down.svg \
	uix/assets/icons/coolicons/arrow/caret_left.svg \
	uix/assets/icons/coolicons/arrow/caret_right.svg \
	uix/assets/icons/coolicons/arrow/caret_up.svg \
	uix/assets/icons/coolicons/arrow/chevron_big_down.svg \
	uix/assets/icons/coolicons/arrow/chevron_big_left.svg \
	uix/assets/icons/coolicons/arrow/chevron_big_right.svg \
	uix/assets/icons/coolicons/arrow/chevron_big_up.svg \
	uix/assets/icons/coolicons/arrow/chevron_down.svg \
	uix/assets/icons/coolicons/arrow/chevron_duo_down.svg \
	uix/assets/icons/coolicons/arrow/chevron_duo_left.svg \
	uix/assets/icons/coolicons/arrow/chevron_duo_right.svg \
	uix/assets/icons/coolicons/arrow/chevron_duo_up.svg \
	uix/assets/icons/coolicons/arrow/chevron_left.svg \
	uix/assets/icons/coolicons/arrow/chevron_right.svg \
	uix/assets/icons/coolicons/arrow/chevron_up.svg \
	uix/assets/icons/coolicons/arrow/circle_chevron_down.svg \
	uix/assets/icons/coolicons/arrow/circle_chevron_left.svg \
	uix/assets/icons/coolicons/arrow/circle_chevron_right.svg \
	uix/assets/icons/coolicons/arrow/circle_chevron_up.svg \
	uix/assets/icons/coolicons/arrow/circle_down.svg \
	uix/assets/icons/coolicons/arrow/circle_left.svg \
	uix/assets/icons/coolicons/arrow/circle_right.svg \
	uix/assets/icons/coolicons/arrow/circle_up.svg \
	uix/assets/icons/coolicons/arrow/expand.svg \
	uix/assets/icons/coolicons/arrow/first_page.svg \
	uix/assets/icons/coolicons/arrow/last_page.svg \
	uix/assets/icons/coolicons/arrow/long_bottom_down.svg \
	uix/assets/icons/coolicons/arrow/long_bottom_up.svg \
	uix/assets/icons/coolicons/arrow/long_down.svg \
	uix/assets/icons/coolicons/arrow/long_left.svg \
	uix/assets/icons/coolicons/arrow/long_right.svg \
	uix/assets/icons/coolicons/arrow/long_up.svg \
	uix/assets/icons/coolicons/arrow/long_up_left_.svg \
	uix/assets/icons/coolicons/arrow/long_up_right.svg \
	uix/assets/icons/coolicons/arrow/short_down.svg \
	uix/assets/icons/coolicons/arrow/short_left.svg \
	uix/assets/icons/coolicons/arrow/short_right.svg \
	uix/assets/icons/coolicons/arrow/short_up.svg \
	uix/assets/icons/coolicons/arrow/shrink.svg \
	uix/assets/icons/coolicons/arrow/small_long_down.svg \
	uix/assets/icons/coolicons/arrow/small_long_left.svg \
	uix/assets/icons/coolicons/arrow/small_long_right.svg \
	uix/assets/icons/coolicons/arrow/small_long_up.svg \
	uix/assets/icons/coolicons/arrow/sub_left.svg \
	uix/assets/icons/coolicons/arrow/sub_right.svg \
	uix/assets/icons/coolicons/arrow/thin_big_down.svg \
	uix/assets/icons/coolicons/arrow/thin_big_left.svg \
	uix/assets/icons/coolicons/arrow/thin_big_right.svg \
	uix/assets/icons/coolicons/arrow/thin_big_up.svg \
	uix/assets/icons/coolicons/arrow/thin_long_02_down.svg \
	uix/assets/icons/coolicons/arrow/thin_long_02_left.svg \
	uix/assets/icons/coolicons/arrow/thin_long_02_right.svg \
	uix/assets/icons/coolicons/arrow/thin_long_02_up.svg \
	uix/assets/icons/coolicons/arrow/thin_long_down.svg \
	uix/assets/icons/coolicons/arrow/thin_long_left.svg \
	uix/assets/icons/coolicons/arrow/thin_long_right.svg \
	uix/assets/icons/coolicons/arrow/thin_long_up.svg \
	uix/assets/icons/coolicons/arrow/unfold_less.svg \
	uix/assets/icons/coolicons/arrow/unfold_more.svg \
	uix/assets/icons/coolicons/attention/error.svg \
	uix/assets/icons/coolicons/attention/error_outline.svg \
	uix/assets/icons/coolicons/attention/info_circle.svg \
	uix/assets/icons/coolicons/attention/info_circle_outline.svg \
	uix/assets/icons/coolicons/attention/info_square.svg \
	uix/assets/icons/coolicons/attention/info_square_outline.svg \
	uix/assets/icons/coolicons/attention/warning.svg \
	uix/assets/icons/coolicons/attention/warning_outline.svg \
	uix/assets/icons/coolicons/basic/Cokie.svg \
	uix/assets/icons/coolicons/basic/Color.svg \
	uix/assets/icons/coolicons/basic/Flag_fill.svg \
	uix/assets/icons/coolicons/basic/Flag_outline.svg \
	uix/assets/icons/coolicons/basic/alarm.svg \
	uix/assets/icons/coolicons/basic/alarm_add.svg \
	uix/assets/icons/coolicons/basic/bulb.svg \
	uix/assets/icons/coolicons/basic/checkbox.svg \
	uix/assets/icons/coolicons/basic/checkbox_checked.svg \
	uix/assets/icons/coolicons/basic/checkbox_square.svg \
	uix/assets/icons/coolicons/basic/circle_check.svg \
	uix/assets/icons/coolicons/basic/circle_check_outline.svg \
	uix/assets/icons/coolicons/basic/circle_checked.svg \
	uix/assets/icons/coolicons/basic/clock.svg \
	uix/assets/icons/coolicons/basic/command.svg \
	uix/assets/icons/coolicons/basic/confused.svg \
	uix/assets/icons/coolicons/basic/credit_card.svg \
	uix/assets/icons/coolicons/basic/credit_card_alt.svg \
	uix/assets/icons/coolicons/basic/done.svg \
	uix/assets/icons/coolicons/basic/done_all.svg \
	uix/assets/icons/coolicons/basic/download.svg \
	uix/assets/icons/coolicons/basic/download_done.svg \
	uix/assets/icons/coolicons/basic/exit.svg \
	uix/assets/icons/coolicons/basic/external_link.svg \
	uix/assets/icons/coolicons/basic/happy.svg \
	uix/assets/icons/coolicons/basic/heart_fill.svg \
	uix/assets/icons/coolicons/basic/heart_outline.svg \
	uix/assets/icons/coolicons/basic/help_circle.svg \
	uix/assets/icons/coolicons/basic/help_circle_outline.svg \
	uix/assets/icons/coolicons/basic/help_questionmark.svg \
	uix/assets/icons/coolicons/basic/image_alt.svg \
	uix/assets/icons/coolicons/basic/label.svg \
	uix/assets/icons/coolicons/basic/layers.svg \
	uix/assets/icons/coolicons/basic/layers_alt.svg \
	uix/assets/icons/coolicons/basic/link.svg \
	uix/assets/icons/coolicons/basic/link_02.svg \
	uix/assets/icons/coolicons/basic/loading.svg \
	uix/assets/icons/coolicons/basic/location.svg \
	uix/assets/icons/coolicons/basic/location_outline.svg \
	uix/assets/icons/coolicons/basic/log_out.svg \
	uix/assets/icons/coolicons/basic/mail.svg \
	uix/assets/icons/coolicons/basic/mail_open.svg \
	uix/assets/icons/coolicons/basic/map.svg \
	uix/assets/icons/coolicons/basic/moon.svg \
	uix/assets/icons/coolicons/basic/off_close.svg \
	uix/assets/icons/coolicons/basic/off_outline_close.svg \
	uix/assets/icons/coolicons/basic/path.svg \
	uix/assets/icons/coolicons/basic/phone.svg \
	uix/assets/icons/coolicons/basic/radio.svg \
	uix/assets/icons/coolicons/basic/radio_filled.svg \
	uix/assets/icons/coolicons/basic/refresh.svg \
	uix/assets/icons/coolicons/basic/refresh_02.svg \
	uix/assets/icons/coolicons/basic/sad.svg \
	uix/assets/icons/coolicons/basic/settings.svg \
	uix/assets/icons/coolicons/basic/settings_filled.svg \
	uix/assets/icons/coolicons/basic/settings_future.svg \
	uix/assets/icons/coolicons/basic/share.svg \
	uix/assets/icons/coolicons/basic/share_outline.svg \
	uix/assets/icons/coolicons/basic/slider_01.svg \
	uix/assets/icons/coolicons/basic/slider_02.svg \
	uix/assets/icons/coolicons/basic/slider_03.svg \
	uix/assets/icons/coolicons/basic/stopwatch.svg \
	uix/assets/icons/coolicons/basic/sun.svg \
	uix/assets/icons/coolicons/basic/trash_empty.svg \
	uix/assets/icons/coolicons/basic/trash_full.svg \
	uix/assets/icons/coolicons/basic/unlink.svg \
	uix/assets/icons/coolicons/brand/Adobe_XD.svg \
	uix/assets/icons/coolicons/brand/Dribbble.svg \
	uix/assets/icons/coolicons/brand/Figma.svg \
	uix/assets/icons/coolicons/brand/LinkedIn.svg \
	uix/assets/icons/coolicons/brand/Sketch.svg \
	uix/assets/icons/coolicons/brand/Twitter.svg \
	uix/assets/icons/coolicons/brand/app_store.svg \
	uix/assets/icons/coolicons/brand/apple.svg \
	uix/assets/icons/coolicons/brand/behance.svg \
	uix/assets/icons/coolicons/brand/coolicons.svg \
	uix/assets/icons/coolicons/brand/css3.svg \
	uix/assets/icons/coolicons/brand/discord.svg \
	uix/assets/icons/coolicons/brand/dropbox.svg \
	uix/assets/icons/coolicons/brand/facebook.svg \
	uix/assets/icons/coolicons/brand/github.svg \
	uix/assets/icons/coolicons/brand/google.svg \
	uix/assets/icons/coolicons/brand/html5.svg \
	uix/assets/icons/coolicons/brand/instagram.svg \
	uix/assets/icons/coolicons/brand/invision.svg \
	uix/assets/icons/coolicons/brand/javascript.svg \
	uix/assets/icons/coolicons/brand/linkpath.svg \
	uix/assets/icons/coolicons/brand/messenger.svg \
	uix/assets/icons/coolicons/brand/paypal.svg \
	uix/assets/icons/coolicons/brand/play_store.svg \
	uix/assets/icons/coolicons/brand/reddit.svg \
	uix/assets/icons/coolicons/brand/slack.svg \
	uix/assets/icons/coolicons/brand/snapchat.svg \
	uix/assets/icons/coolicons/brand/spectrum.svg \
	uix/assets/icons/coolicons/brand/spotify.svg \
	uix/assets/icons/coolicons/brand/stack_overflow.svg \
	uix/assets/icons/coolicons/brand/trello.svg \
	uix/assets/icons/coolicons/brand/unsplash.svg \
	uix/assets/icons/coolicons/brand/youtube.svg \
	uix/assets/icons/coolicons/calendar/calendar.svg \
	uix/assets/icons/coolicons/calendar/calendar_calendar.svg \
	uix/assets/icons/coolicons/calendar/calendar_check.svg \
	uix/assets/icons/coolicons/calendar/calendar_edit.svg \
	uix/assets/icons/coolicons/calendar/calendar_event.svg \
	uix/assets/icons/coolicons/calendar/calendar_minus.svg \
	uix/assets/icons/coolicons/calendar/calendar_plus.svg \
	uix/assets/icons/coolicons/calendar/calendar_week.svg \
	uix/assets/icons/coolicons/calendar/calendar_x.svg \
	uix/assets/icons/coolicons/chart/bar_chart.svg \
	uix/assets/icons/coolicons/chart/bar_chart_alt.svg \
	uix/assets/icons/coolicons/chart/bar_chart_horizontal.svg \
	uix/assets/icons/coolicons/chart/bar_chart_square.svg \
	uix/assets/icons/coolicons/chart/doughnut_chart.svg \
	uix/assets/icons/coolicons/chart/line_chart_down.svg \
	uix/assets/icons/coolicons/chart/line_chart_up.svg \
	uix/assets/icons/coolicons/chart/pie_chart_25.svg \
	uix/assets/icons/coolicons/chart/pie_chart_50.svg \
	uix/assets/icons/coolicons/chart/pie_chart_75.svg \
	uix/assets/icons/coolicons/chart/pie_chart_outline.svg \
	uix/assets/icons/coolicons/chart/pie_chart_outline_25.svg \
	uix/assets/icons/coolicons/chart/trending_down.svg \
	uix/assets/icons/coolicons/chart/trending_up.svg \
	uix/assets/icons/coolicons/device/devices.svg \
	uix/assets/icons/coolicons/device/laptop.svg \
	uix/assets/icons/coolicons/device/mobile.svg \
	uix/assets/icons/coolicons/device/mobile_alt.svg \
	uix/assets/icons/coolicons/device/monitor.svg \
	uix/assets/icons/coolicons/device/tablet.svg \
	uix/assets/icons/coolicons/edit/add_to_queue.svg \
	uix/assets/icons/coolicons/edit/comment.svg \
	uix/assets/icons/coolicons/edit/comment_check.svg \
	uix/assets/icons/coolicons/edit/comment_minus.svg \
	uix/assets/icons/coolicons/edit/comment_plus.svg \
	uix/assets/icons/coolicons/edit/copy.svg \
	uix/assets/icons/coolicons/edit/edit.svg \
	uix/assets/icons/coolicons/edit/hide.svg \
	uix/assets/icons/coolicons/edit/list_check.svg \
	uix/assets/icons/coolicons/edit/list_minus.svg \
	uix/assets/icons/coolicons/edit/list_ol.svg \
	uix/assets/icons/coolicons/edit/list_plus.svg \
	uix/assets/icons/coolicons/edit/list_ul.svg \
	uix/assets/icons/coolicons/edit/minus.svg \
	uix/assets/icons/coolicons/edit/minus_circle.svg \
	uix/assets/icons/coolicons/edit/minus_circle_outline.svg \
	uix/assets/icons/coolicons/edit/minus_square.svg \
	uix/assets/icons/coolicons/edit/move.svg \
	uix/assets/icons/coolicons/edit/move_horizontal.svg \
	uix/assets/icons/coolicons/edit/move_vertical.svg \
	uix/assets/icons/coolicons/edit/plus.svg \
	uix/assets/icons/coolicons/edit/plus_circle.svg \
	uix/assets/icons/coolicons/edit/plus_circle_outline.svg \
	uix/assets/icons/coolicons/edit/plus_square.svg \
	uix/assets/icons/coolicons/edit/search.svg \
	uix/assets/icons/coolicons/edit/search_small.svg \
	uix/assets/icons/coolicons/edit/search_small_minus.svg \
	uix/assets/icons/coolicons/edit/search_small_plus.svg \
	uix/assets/icons/coolicons/edit/select_multiple.svg \
	uix/assets/icons/coolicons/edit/show.svg \
	uix/assets/icons/coolicons/edit/text_align_center.svg \
	uix/assets/icons/coolicons/edit/text_align_justify.svg \
	uix/assets/icons/coolicons/edit/text_align_left.svg \
	uix/assets/icons/coolicons/edit/text_align_right.svg \
	uix/assets/icons/coolicons/file/cloud.svg \
	uix/assets/icons/coolicons/file/cloud_check.svg \
	uix/assets/icons/coolicons/file/cloud_close.svg \
	uix/assets/icons/coolicons/file/cloud_down.svg \
	uix/assets/icons/coolicons/file/cloud_off.svg \
	uix/assets/icons/coolicons/file/cloud_outline.svg \
	uix/assets/icons/coolicons/file/cloud_up.svg \
	uix/assets/icons/coolicons/file/file_blank.svg \
	uix/assets/icons/coolicons/file/file_find.svg \
	uix/assets/icons/coolicons/file/file_minus.svg \
	uix/assets/icons/coolicons/file/file_new.svg \
	uix/assets/icons/coolicons/file/folder.svg \
	uix/assets/icons/coolicons/file/folder_minus.svg \
	uix/assets/icons/coolicons/file/folder_open.svg \
	uix/assets/icons/coolicons/file/folder_plus.svg \
	uix/assets/icons/coolicons/file/note.svg \
	uix/assets/icons/coolicons/grid/dashboard.svg \
	uix/assets/icons/coolicons/grid/dashboard_02.svg \
	uix/assets/icons/coolicons/grid/grid.svg \
	uix/assets/icons/coolicons/grid/grid_big.svg \
	uix/assets/icons/coolicons/grid/grid_big_round.svg \
	uix/assets/icons/coolicons/grid/grid_horizontal.svg \
	uix/assets/icons/coolicons/grid/grid_horizontal_round.svg \
	uix/assets/icons/coolicons/grid/grid_round.svg \
	uix/assets/icons/coolicons/grid/grid_small.svg \
	uix/assets/icons/coolicons/grid/grid_small_round.svg \
	uix/assets/icons/coolicons/grid/grid_vertical.svg \
	uix/assets/icons/coolicons/grid/grid_vertical_round.svg \
	uix/assets/icons/coolicons/media/airplay.svg \
	uix/assets/icons/coolicons/media/cast.svg \
	uix/assets/icons/coolicons/media/fast_forward.svg \
	uix/assets/icons/coolicons/media/fast_rewind.svg \
	uix/assets/icons/coolicons/media/pause_circle_filled.svg \
	uix/assets/icons/coolicons/media/pause_circle_outline.svg \
	uix/assets/icons/coolicons/media/play_arrow.svg \
	uix/assets/icons/coolicons/media/play_circle_filled.svg \
	uix/assets/icons/coolicons/media/play_circle_outline.svg \
	uix/assets/icons/coolicons/media/repeat.svg \
	uix/assets/icons/coolicons/media/shuffle.svg \
	uix/assets/icons/coolicons/media/skip_next.svg \
	uix/assets/icons/coolicons/media/skip_previous.svg \
	uix/assets/icons/coolicons/menu/close_big.svg \
	uix/assets/icons/coolicons/menu/close_small.svg \
	uix/assets/icons/coolicons/menu/hamburger.svg \
	uix/assets/icons/coolicons/menu/menu_alt_01.svg \
	uix/assets/icons/coolicons/menu/menu_alt_02.svg \
	uix/assets/icons/coolicons/menu/menu_alt_03.svg \
	uix/assets/icons/coolicons/menu/menu_alt_04.svg \
	uix/assets/icons/coolicons/menu/menu_alt_05.svg \
	uix/assets/icons/coolicons/menu/menu_duo.svg \
	uix/assets/icons/coolicons/menu/more_horizontal.svg \
	uix/assets/icons/coolicons/menu/more_vertical.svg \
	uix/assets/icons/coolicons/misc/dot_01_xs.svg \
	uix/assets/icons/coolicons/misc/dot_02_s.svg \
	uix/assets/icons/coolicons/misc/dot_03_m.svg \
	uix/assets/icons/coolicons/misc/dot_04_l.svg \
	uix/assets/icons/coolicons/misc/dot_05_xl.svg \
	uix/assets/icons/coolicons/notification/notification.svg \
	uix/assets/icons/coolicons/notification/notification_active.svg \
	uix/assets/icons/coolicons/notification/notification_deactivated.svg \
	uix/assets/icons/coolicons/notification/notification_dot.svg \
	uix/assets/icons/coolicons/notification/notification_outline.svg \
	uix/assets/icons/coolicons/notification/notification_outline_dot.svg \
	uix/assets/icons/coolicons/notification/notification_outline_minus.svg \
	uix/assets/icons/coolicons/notification/notification_outline_plus.svg \
	uix/assets/icons/coolicons/notification/notification_plus.svg \
	uix/assets/icons/coolicons/system/bar_bottom.svg \
	uix/assets/icons/coolicons/system/bar_left.svg \
	uix/assets/icons/coolicons/system/bar_right.svg \
	uix/assets/icons/coolicons/system/bar_top.svg \
	uix/assets/icons/coolicons/system/code.svg \
	uix/assets/icons/coolicons/system/cylinder.svg \
	uix/assets/icons/coolicons/system/data.svg \
	uix/assets/icons/coolicons/system/terminal.svg \
	uix/assets/icons/coolicons/system/transfer.svg \
	uix/assets/icons/coolicons/system/window.svg \
	uix/assets/icons/coolicons/system/window_check.svg \
	uix/assets/icons/coolicons/system/window_close.svg \
	uix/assets/icons/coolicons/system/window_code_block.svg \
	uix/assets/icons/coolicons/system/window_sidebar.svg \
	uix/assets/icons/coolicons/system/window_terminal.svg \
	uix/assets/icons/coolicons/user/id_card.svg \
	uix/assets/icons/coolicons/user/user.svg \
	uix/assets/icons/coolicons/user/user_check.svg \
	uix/assets/icons/coolicons/user/user_circle.svg \
	uix/assets/icons/coolicons/user/user_minus.svg \
	uix/assets/icons/coolicons/user/user_pin.svg \
	uix/assets/icons/coolicons/user/user_plus.svg \
	uix/assets/icons/coolicons/user/user_voice.svg \
	uix/assets/icons/coolicons/user/user_x.svg \
	uix/components/containers/Page.qml \
	uix/components/containers/StackView.qml \
	uix/main.qml \
	uix/scripts/constants/color.js \
	uix/scripts/constants/network.mjs \
	uix/scripts/lib/httpclient.js

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
	ANDROID_PACKAGE_SOURCE_DIR = \
		$$PWD/android
}
