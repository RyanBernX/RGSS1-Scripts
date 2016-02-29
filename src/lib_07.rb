=begin
使用方法 
全选后插入到main前面，只有在Pictures\下面放入6张图片：start-1.png，start-2.png，continue-1png，continue-2.png，exit-1.png，exit-2.png  
脚本冲突可能：各种涉及了Title的脚本都有可能冲突。 
编者注：建立一个新工程，然后将下载的范例提供的内容全部粘贴过去，替换原文件 
 
=end
#============================================================================== 
# 本脚本来自[url]www.66RPG.com[/url]，使用和转载请保留此信息 
#============================================================================== 
#============================================================================== 
# ■ 图片标题菜单1.0 
# Scene_Title 
#------------------------------------------------------------------------------ 
# 作者：chaochao 
# [url]http://zhuchao.go1.icpcn.com[/url] 
#============================================================================== 
class Scene_Title 
  def main 
    if $BTEST 
      battle_test 
      return 
    end 
    $data_actors = load_data("Data/Actors.rxdata") 
    $data_classes = load_data("Data/Classes.rxdata") 
    $data_skills = load_data("Data/Skills.rxdata") 
    $data_items = load_data("Data/Items.rxdata") 
    $data_weapons = load_data("Data/Weapons.rxdata") 
    $data_armors = load_data("Data/Armors.rxdata") 
    $data_enemies = load_data("Data/Enemies.rxdata") 
    $data_troops = load_data("Data/Troops.rxdata") 
    $data_states = load_data("Data/States.rxdata") 
    $data_animations = load_data("Data/Animations.rxdata") 
    $data_tilesets = load_data("Data/Tilesets.rxdata") 
    $data_common_events = load_data("Data/CommonEvents.rxdata") 
    $data_system = load_data("Data/System.rxdata") 
    $game_system = Game_System.new 
    # 生成标题图形 
    @sprite = [Sprite.new] 
    for i in 0..6 
      @sprite[i] = Sprite.new 
      @sprite[i].opacity = 0 
    end 
    @sprite[0].bitmap = RPG::Cache.title($data_system.title_name) 
    @sprite[0].opacity = 0 
    #开始游戏的图片 
    @sprite[1].bitmap = Bitmap.new("Graphics/Pictures/start-1.png") 
    @sprite[2].bitmap = Bitmap.new("Graphics/Pictures/start-2.png") 
    #继续游戏的图片 
    @sprite[3].bitmap = Bitmap.new("Graphics/Pictures/continue-1.png") 
    @sprite[4].bitmap = Bitmap.new("Graphics/Pictures/continue-2.png") 
    #结束游戏的图片 
    @sprite[5].bitmap = Bitmap.new("Graphics/Pictures/exit-1.png") 
    @sprite[6].bitmap = Bitmap.new("Graphics/Pictures/exit-2.png") 
    #图片位置 
    for i in 1..6 
      x=110 
      y=(i+1)/2*35+240 
      @sprite[i].x =x 
      @sprite[i].y =y 
    end 
    @continue_enabled = false 
    for i in 0..3 
      if FileTest.exist?("Save#{i+1}.rxdata") 
        @continue_enabled = true 
      end 
    end 
    if @continue_enabled 
      @command_index = 1 
    else 
      @command_index = 0 
      @sprite[3].tone = Tone.new(0, 0, 0, 255) 
      @sprite[4].tone = Tone.new(0, 0, 0, 255) 
    end 
    $game_system.bgm_play($data_system.title_bgm) 
    Audio.me_stop 
    Audio.bgs_stop 
    Graphics.transition 
    loop do 
      Graphics.update 
      #淡出背景圖形 
      if @sprite[0].opacity <= 255 
        @sprite[0].opacity += 15 
      end 
      Input.update 
      update 
      if $scene != self 
        break 
      end 
    end 
    Graphics.freeze 
    # 釋放圖形 
    for i in 0..6 
      @sprite[i].bitmap.dispose 
      @sprite[i].dispose 
    end 
  end 
  def update 
  chaochaocommandchaochao 
  if Input.trigger?(Input::C) 
    case @command_index 
      when 0 
        command_new_game 
      when 1 
        command_continue 
      when 2 
        command_shutdown 
      end 
    end 
  end 
  def chaochaocommandchaochao 
    if Input.trigger?(Input::UP) 
      @command_index -= 1 
      if @command_index < 0 
        @command_index = 2 
      end 
      $game_system.se_play($data_system.cursor_se) 
    end 
    if Input.trigger?(Input::DOWN) 
      @command_index += 1 
      if @command_index > 2 
        @command_index = 0 
      end 
      $game_system.se_play($data_system.cursor_se) 
    end 
    case @command_index 
    when 0 
      if @sprite[1].opacity >= 0 
        @sprite[1].opacity -= 30 
      end 
      if @sprite[2].opacity <= 240 
        @sprite[2].opacity += 30 
      end 
      if @sprite[3].opacity <= 210 
        @sprite[3].opacity += 30 
      end 
      if @sprite[4].opacity >= 0 
        @sprite[4].opacity -= 30 
      end 
      if @sprite[5].opacity <= 210 
        @sprite[5].opacity += 30 
      end 
      if @sprite[6].opacity >= 0 
        @sprite[6].opacity -= 30 
      end 
    when 1 
      if @sprite[1].opacity <= 210 
        @sprite[1].opacity += 30 
      end 
      if @sprite[2].opacity >= 0 
        @sprite[2].opacity -= 30 
      end 
      if @sprite[3].opacity >= 0 
        @sprite[3].opacity -= 30 
      end 
      if @sprite[4].opacity <= 240 
        @sprite[4].opacity += 30 
      end 
      if @sprite[5].opacity <= 210 
        @sprite[5].opacity += 30 
      end 
      if @sprite[6].opacity >= 0 
        @sprite[6].opacity -= 30 
      end 
    when 2 
      if @sprite[1].opacity <= 210 
        @sprite[1].opacity += 30 
      end 
      if @sprite[2].opacity >= 0 
        @sprite[2].opacity -= 30 
      end 
      if @sprite[3].opacity <= 210 
        @sprite[3].opacity += 30 
      end 
      if @sprite[4].opacity >= 0 
        @sprite[4].opacity -= 30 
      end 
      if @sprite[5].opacity >= 0 
        @sprite[5].opacity -= 30 
      end 
      if @sprite[6].opacity <= 240 
        @sprite[6].opacity += 30 
      end 
    end 
  end 
end 
#============================================================================== 
# 本脚本来自[url]www.66RPG.com[/url]，使用和转载请保留此信息 
#==============================================================================
