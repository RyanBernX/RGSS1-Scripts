#=============================================================================
# 紧急操作事件（Quick Time Event）小插件 Ver 1.1
#-----------------------------------------------------------------------------
# 作者：RyanBern
#=============================================================================
 
#=============================================================================
# 功能说明：
#-----------------------------------------------------------------------------
# 可以实现在RMXP游戏进行中的QTE，虽然把QTE放在RPG游戏中感觉很奇怪，没什么用。
# 但是为了好玩，就做了一个这个。如果有全键盘脚本的话，对此插件稍微加点
# 改动就可以实现更多按键的QTE。不过本脚本针对的是原装脚本的输入系统而编写的。
# 插件较朴素，只是实现了一些简单的功能，有时间我会陆续添加。
#-----------------------------------------------------------------------------
# 这里包含两种QTE的模式：单按键瞬时紧急事件（QTE_Single）和按键组蓄力紧急事件
# （QTE_Combination）。前者是在适当时间点按下规定的按键即可完成一次QTE，又分为
# 有时限和无时限两种；后者是在一定时间内依照次序不断输入按键组，达到规定次数就
# 可以完成QTE，也分为有时限和无时限两种。
#-----------------------------------------------------------------------------
# 有关脚本的兼容性，本脚本在新工程的环境下编写，新增了若干模块，对原有的脚本
# 改动极小，经过简单整合就可以实现兼容。但是对于RTAB战斗系统的兼容性未经测试
#=============================================================================
 
#=============================================================================
# 使用说明：
#-----------------------------------------------------------------------------
# 我已经在地图场景（Scene_Map）和战斗场景（Scene_Battle）添加了这两种QTE的插件
# 不用的时候它们隐藏在场景中，如果使用的时候，可以通过事件“脚本”命令进行手动
# 激活。
#-----------------------------------------------------------------------------
# 单按键瞬时紧急事件（QTE_Single）的启动方法
# qte = $scene.get_QTE_single    # 取得当前场景的QTE_Single插件
# qte.time_limit = XX            # 设置时限，单位是帧，如果不想设置时间限制，请设置为0
# qte.keys = [XX,XX]            # 设置按键，可以设置多个，玩家必须按照次序全部按对才算QTE成功
# qte.success_field = [[XX,XX], [XX,XX]]
#                                # 设置有效按键区域，最大范围是[0,100]
#                                  例如设置[50,60]表示只有在指针经过这个区域按下
#                                  指定按键才算QTE成功，每个按键都必须设置，否则会报错。
# qte.non_mistake_mode = true/false
#                                # 设置是否允许按错，这里按错的定义是按错按键或者按对了
#                                  但是没有在规定区域上。如果设置为true则按错一次QTE就会失败。
# qte.start                      # 激活QTE插件
# QTE结束后，可以使用
# $scene.get_QTE_single.result   # 显示最近一次QTE结果，成功为true，失败为false
#-----------------------------------------------------------------------------
# 按键组蓄力紧急事件（QTE_Combination）的启动方法
# qte = $scene.get_QTE_com       # 取得当前场景的QTE_Combination插件
# qte.time_limit = XX            # 设置时限，单位是帧，如果不想设置时间限制，请设置为0
# qte.key_set = [XX,XX,…,XX]    # 设置按键组，例如[Input::LEFT,Input::Right]
#                                  表示需要按照顺序按下这一组键才能蓄力，循环操作
# qte.power_need = XX            # 设置QTE成功需要的蓄力能量
# qte.power_increment = XX       # 设置成功按键一次后，增加的能量
# qte.power_decrement = XX       # 设置自动随时间减少的能量，单位是 能量/帧，数值不宜过
#                                  大，否则会很变态。
# qte.start                      # 激活QTE插件
# QTE结束后，可以使用
# $scene.get_QTE_single.result   # 显示最近一次QTE结果，成功为true，失败为false
#-----------------------------------------------------------------------------
# 注意事项（重要）：
#-----------------------------------------------------------------------------
# 1.使用事件“脚本”指令设置并开启QTE插件后，需要设置“等待 3 帧”，然后再使用
#   事件“条件分歧——脚本——$scene.get_QTE_Xx.result”进行分歧，否则事件解释
#   器会提前进行判断。
# 2.如果QTE组件被激活，那么场景的update会优先刷新QTE组件，而其它模块的刷新会暂
#   时停止。QTE完成后，再进行正常刷新。
# 3.不可以同时激活两种QTE插件。
# 4.禁止在非地图场景和战斗场景里面获取相应的QTE组件。
# 5.如果对技能里面使用QTE，建议把技能的效果全都放到公共事件中，效果范围设置
#   为[无]，之后关联公共事件，先开启QTE，然后“等待 3 帧”，再对QTE结果做伤
#   害处理。 
#=============================================================================
 
#=============================================================================
# 更新记录
#-----------------------------------------------------------------------------
# Ver 1.1 : 修改 QTE_Single，增加功能可以连续点击一组按键，同时QTE_Single具备
#           了按错即QTE失败的功能。原QTE_Combination功能不变。
#           注：QTE_Single中的字段做了修改，和1.0不兼容。
#=============================================================================
 
#=============================================================================
# 素材/基础设定
#=============================================================================
module QTE
  # QTE 组件游标图，大小 24*24，放在Graphis/Icons下
  ICON_NAME = "047-Skill04.png"
  # QTE 成功播放 SE
  SUCCEEDED_SE = "Audio/SE/002-System02"
  # QTE 失败播放 SE
  FAILED_SE = "Audio/SE/004-System04"
  # 可用 QTE 按键集合及用语设定
  ALL_KEYS = {
              Input::A => "Z",  Input::B => "X", Input::C => "Space", 
              Input::UP => "↑", Input::DOWN => "↓", Input::LEFT => "←",
              Input::RIGHT => "→", Input::SHIFT => "Shift", 
              Input::CTRL => "Ctrl", Input::ALT => "ALT"
              }
end
 
module Input
  def self.key_trigger?
    return QTE::ALL_KEYS.keys.any?{|key| self.trigger?(key)}
  end
end
 
class Window_QTE_Base < Window_Base
  attr_accessor :time_limit
  attr_reader   :activated
  attr_reader   :result
  def initialize
    super(-160, 320, 160, 96)
    self.z = 999
    self.visible = false
    @activated = false
    @result = false
    @state = 0
    @time_limit = 0
    @time_count = 0
    @arrow_sprite = Sprite.new
    @arrow_sprite.bitmap =  Bitmap.new(24, 24)
    if QTE::ICON_NAME != ""
      @arrow_sprite.bitmap = RPG::Cache.icon(QTE::ICON_NAME)
    end
    @x_increment = 16
    @y_increment = 56
    @arrow_sprite.x = self.x + @x_increment
    @arrow_sprite.y = self.y + @y_increment
    @arrow_sprite.z = self.z + 10
    @arrow_sprite.ox = @arrow_sprite.bitmap.width / 2
    @arrow_sprite.oy = @arrow_sprite.bitmap.height / 2
  end
  def visible=(val)
    @arrow_sprite.visible = val if @arrow_sprite != nil
    super(val)
  end
  def x=(new_x)
    @arrow_sprite.x = new_x + @x_increment if @arrow_sprite != nil
    super(new_x)
  end
  def y=(new_y)
    @arrow_sprite.y = new_y + @y_increment if @arrow_sprite != nil
    super(new_y)
  end
  def z=(new_z)
    @arrow_sprite.z = new_z + 10 if @arrow_sprite != nil
    super(new_z)
  end
  def start
    self.visible = true
    reset
    for i in 0...16
      self.x += 10
      Graphics.update
    end
    @activated = true
  end
  def update
    super
  end
  def dispose
    @arrow_sprite.bitmap.dispose
    @arrow_sprite.dispose
    super
  end
  def reset
    @x_increment = 16
    self.x = -160
    @time_count = 0
    @state = 0
    @result = false
    refresh
  end
  def terminate(qte_result)
    @result = qte_result
    @activated = false
    for i in 0...16
      self.x -= 10
      Graphics.update
    end
    self.visible = false
  end
end
 
class Window_QTE_Single < Window_QTE_Base
  attr_writer   :keys
  attr_writer   :success_fields
  attr_accessor :non_mistake_mode
  def initialize(keys, fields, non_mistake_mode = false)
    super()
    @keys = keys
    @success_fields = fields
    @non_mistake = non_mistake_mode
    self.contents = Bitmap.new(width - 32, height - 32)
    refresh
  end
  def refresh
    self.contents.clear
    text = QTE::ALL_KEYS[@keys[@state]] || ""
    self.contents.draw_text(4, 0, 128, 32, "按下：" + text)
    draw_bar
  end
  def draw_bar
    w = 128
    w1 = Integer((w-2) * @success_fields[@state][0] / 100.0)
    w2 = Integer((w-2) * @success_fields[@state][1] / 100.0)
    self.contents.fill_rect(0,48,w,8,Color.new(255,255,255,255))
    self.contents.fill_rect(1,49,w-2,6,Color.new(0,0,0,255))
    self.contents.fill_rect(w1,50,w2-w1,1,Color.new(0,150,0,255))
    self.contents.fill_rect(w1,51,w2-w1,1,Color.new(0,200,0,255))
    self.contents.fill_rect(w1,52,w2-w1,1,Color.new(0,150,0,255))
  end
  def update
    super
    update_arrow
    if Input.key_trigger?
      update_input
    end
    terminate(true) if @state == @keys.size
    terminate(false) if @time_limit > 0 && @time_count > @time_limit
  end
  def update_arrow
    if @time_limit == 0
      if @time_count >= 100
        @step = -4
      end
      if @time_count <= 0
        @step = 4
      end
      @time_count += @step
      @x_increment = 16 + Integer(@time_count * 128 / 100.0)
    else
      @time_count += 1
      @x_increment = 16 + Integer(1.0 * @time_count * 128 / @time_limit)
    end
    @arrow_sprite.x = self.x + @x_increment
  end
  def update_input
    if @time_limit == 0
      in_field = @time_count <= @success_fields[@state][1] && @time_count >= @success_fields[@state][0]
    else
      time = 100.0 * @time_count / @time_limit
      in_field = time <= @success_fields[@state][1] && time >= @success_fields[@state][0]
    end
    if Input.trigger?(@keys[@state]) && in_field
      Audio.se_play(QTE::SUCCEEDED_SE)
      @state += 1
      @time_count = 0
      refresh if @state < @keys.size
    elsif @non_mistake_mode
      Audio.se_play(QTE::FAILED_SE)
      terminate(false)
    end
  end      
end
class Window_QTE_Combination < Window_QTE_Base
  attr_reader :power
  attr_writer :key_set
  attr_writer :power_need
  attr_writer :power_increment
  attr_writer :power_decrement
  def initialize(key_set, power_need, increment, decrement)
    super()
    @key_set = key_set
    @state = 0
    @power = 0
    @power_need = power_need
    @power_increment = increment
    @power_decrement = decrement
    self.time_limit = 0
    self.contents = Bitmap.new(width - 32, height - 32)
    refresh
  end
  def power=(val)
    if @power != val
      @power = val
      if @power < 0
        @power = 0
      end
      draw_bar
    end
  end
  def reset
    super
    self.power = 0
    @state = 0
    if @time_limit == 0
      @arrow_sprite.visible = false
    end
  end
  def refresh
    self.contents.clear
    text = ""
    for i in [email]0...@key_set.size[/email]
      key = @key_set[i]
      text += QTE::ALL_KEYS[@key_set[i]] || ""
      text += "+" if i != @key_set.size - 1
    end
    self.contents.draw_text(4, 0, 128, 32, "猛击：" + text)
    draw_bar
  end
  def draw_bar
    w = 128
    w1 = Integer(1.0 * (w-2) * @power / @power_need)
    w1 = w-2 if w1 > w
    self.contents.fill_rect(0,48,w,8,Color.new(255,255,255,255))
    self.contents.fill_rect(1,49,w-2,6,Color.new(0,0,0,255))
    self.contents.fill_rect(1,50,w1,1,Color.new(0,150,0,255))
    self.contents.fill_rect(1,51,w1,1,Color.new(0,200,0,255))
    self.contents.fill_rect(1,52,w1,1,Color.new(0,150,0,255))
  end
  def update
    super
    if @time_limit == 0
      key = @key_set[@state]
      if Input.trigger?(key)
        self.power += @power_increment
        @state += 1
        @state %= @key_set.size
      end
      self.power -= @power_decrement
      if @power >= @power_need
        Audio.se_play(QTE::SUCCEEDED_SE)
        terminate(true)
        return
      end
    elsif @time_limit > 0
      @time_count += 1
      @x_increment = 16 + Integer(1.0 * @time_count * 128 / @time_limit)
      @arrow_sprite.x = self.x + @x_increment
      key = @key_set[@state]
      if Input.trigger?(key)
        self.power += @power_increment
        @state += 1
        @state %= @key_set.size
      end
      self.power -= @power_decrement
      if @power >= @power_need
        Audio.se_play(QTE::SUCCEEDED_SE)
        terminate(true)
        return
      end
      if @time_count >= @time_limit
        Audio.se_play(QTE::FAILED_SE)
        terminate(false)
        return
      end
    end
  end
end
 
class Scene_Map
  alias qte_main main
  def main
    @qte_single = Window_QTE_Single.new(Input::C, [0,100])
    @qte_com = Window_QTE_Combination.new([Input::C], 500, 50, 0)
    qte_main
    @qte_single.dispose
    @qte_com.dispose
  end
  alias qte_update update
  def update
    if @qte_single.activated
      @qte_single.update
      return
    end
    if @qte_com.activated
      @qte_com.update
      return
    end
    qte_update
  end
  def get_QTE_single
    return @qte_single
  end
  def get_QTE_com
    return @qte_com
  end
end
 
class Scene_Battle
  alias qte_main main
  def main
    @qte_single = Window_QTE_Single.new(Input::C, [0,100])
    @qte_com = Window_QTE_Combination.new([Input::C], 500, 50, 0)
    qte_main
    @qte_single.dispose
    @qte_com.dispose
  end
  alias qte_update update
  def update
    if @qte_single.activated
      @qte_single.update
      return
    end
    if @qte_com.activated
      @qte_com.update
      return
    end
    qte_update
  end
  def get_QTE_single
    return @qte_single
  end
  def get_QTE_com
    return @qte_com
  end
end

