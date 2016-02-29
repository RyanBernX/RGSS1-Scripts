#==========================================================================
# 本脚本来自[url]www.66rpg.com[/url]，用于任何游戏请保留此信息。
#==========================================================================
 
VAR_SWITCH = 26          # 26号开关打开此脚本才工作，关闭则停止运算，并且透明
VAR_REFRESH_SWITCH = 27  # 27号开关控制强制刷新，使用时机：1、把窗口由透明变为不透明(包括第一次使用时)，2、游戏中用脚本更改了$var
 
$var = []
$var = [[1,0,0],[2,32,32],[3,64,32]] #所有需要显示在地图并且刷新的变量，可在游戏中用脚本更改。格式：[变量编号，x坐标，y坐标]
 
#==============================================================================
# ■ Window_Var
#------------------------------------------------------------------------------
# 　显示变量的窗口。
#==============================================================================
class Window_Var < Window_Base#注意前面那个window_var是文件名
  #--------------------------------------------------------------------------
  # ● 初始化窗口
  #--------------------------------------------------------------------------
  def initialize
    super(-16, -16, 640+32, 480+32)#最后面那个数字是宽要显示多个需要改大,前面一个是长~
    self.contents = Bitmap.new(width - 32, height - 32)
    self.back_opacity = 255  # 这个是背景透明
    self.opacity = 255       # 这个是边框和背景都透明
    self.contents_opacity = 255       # 这个是内容透明
    self.visible = false
    self.z=9999
    @var = $var
    @var_a = []
    for var_draw in $var
      @var_a[var_draw[0]] = $game_variables[var_draw[0]]
    end    
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 刷新
  #--------------------------------------------------------------------------
  def refresh
    if $game_switches[VAR_SWITCH]
      @var = $var         # 记录现在变量数组结构
      self.contents.clear # 清除以前的东西
      for var_draw in @var
        @var_a[var_draw[0]] = $game_variables[var_draw[0]] # 记录现在的游戏变量
        self.contents.draw_text(var_draw[1],var_draw[2],640,32,@var_a[var_draw[0]].to_s)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 判断文字刷新。节约内存用
  #--------------------------------------------------------------------------
  def judge
    for var_draw in $var
      if @var_a[var_draw[0]] != $game_variables[var_draw[0]] #如果现在记录的变量和游戏变量不同，刷新
        return true
      end
    end
    if $game_switches[VAR_REFRESH_SWITCH]  # 强制刷新的时候，刷新
      $game_switches[VAR_REFRESH_SWITCH] = false
      return true 
    end
    return false
  end
end
 
class Scene_Map
  alias var_66rpg_main main
  def main
    @var_window = Window_Var.new
    @var_window.opacity = 0
    var_66rpg_main
    @var_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● 刷新画面
  #--------------------------------------------------------------------------
  alias var_66rpg_update update
  def update
    var_66rpg_update
    if $game_switches[VAR_SWITCH]
      @var_window.visible = true      
      @var_window.refresh if @var_window.judge
    else
      @var_window.visible = false
    end
  end
end
#==========================================================================
# 本脚本来自[url]www.66rpg.com[/url]，用于任何游戏请保留此信息。
#==========================================================================
