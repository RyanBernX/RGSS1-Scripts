#==============================================================================
# ■ 技能装备系统 for RGSS1 by：VIPArcher
#  -- 本脚本来自 [url]http://rm.66rpg.com[/url] 使用或转载请保留以上信息。
#==============================================================================
#  让技能可以像装备一样装备到角色身上，战斗中仅可使用已经装备的技能，其他场景可
#  以随意使用，技能装备场景技能槽栏激活状态下（如有队友）按左右键切换当前角色。
#  $scene = Scene_SetEquipSkill.new(actor_index, skill_index)   呼出场景。
#  actor_index : 该角色在队伍中的位置 ; skill_index : 技能槽光标的起始位置
#==============================================================================
$VIPArcherScript ||= {};$VIPArcherScript[:battle_skill] = 20150717
#-------------------------------------------------------------------------------
module VIPArcher end
#==============================================================================
# ★ 设定部分 ★
#==============================================================================
module VIPArcher::Battle_Skill
  #技能槽名字
  Skills_Slot_Name = ['技能槽一','技能槽二','技能槽三','技能槽四','技能槽五']
  #可使用的场合名称
  SKILL_OCCASION   = ['平时', '战斗中', '菜单中', '不能使用']
  #效果范围名称
  SKILL_SCOPE      = ['无', '敌单体', '敌全体', '己方单体', '己方全体',
                    '己方单体（战斗不能）', '己方全体（战斗不能）', '使用者']
  #未装备技能时技能槽显示内容
  BLANK_TEXT   = '-  空技能槽  -'
  #空技能槽帮助窗口文本
  BLANK_HELP   = '空的技能槽，可以装备战斗技能。'
  #"[卸下技能]"的图标文件名(不需要则设置为 nil 或 false)
  RELEASE_ICON = '047-Skill04'
  #"[卸下技能]"帮助窗口文本
  RELEASE_HELP = '卸下已装备的技能。'
  #"[卸下技能]"按钮名称
  RELEASE_TEXT = '[卸下技能]'
end
#==============================================================================
# ☆ 设定结束 ☆
#==============================================================================
class Symbol
  def to_proc
    Proc.new { |*args| args.shift.__send__(self, *args) }
  end
end
class Game_Actor < Game_Battler
  include VIPArcher::Battle_Skill
  attr_reader :battle_skill #已装备技能
  alias battle_skill_initialize initialize
  def initialize(actor_id)
    @battle_skill = Array.new(Skills_Slot_Name.size){ nil }
    battle_skill_initialize(actor_id)
  end
  def add_battle_skill(skill,id)
    @battle_skill[id] = nil if skill.zero?
    return if @battle_skill.include?(skill)
    @battle_skill[id] = skill if skills.include?(skill)
  end
  alias battle_skill_learn_skill learn_skill
  def learn_skill(skill_id)
    battle_skill_learn_skill(skill_id)
    auto_add_battle_skill(skill_id) unless @battle_skill.include?(skill_id)
  end
  def auto_add_battle_skill(skill_id)
    @battle_skill.each_index do |index|
      return @battle_skill[index] = skill_id if @battle_skill[index].nil?
    end
  end
  alias battle_skill_forget_skill forget_skill
  def forget_skill(skill_id)
    battle_skill_forget_skill(skill_id)
    if @battle_skill.include?(skill_id)
      @battle_skill[@battle_skill.index(skill_id)] = nil
    end
  end
end
class Window_Selectable < Window_Base
  def create_contents
    self.contents.dispose if self.contents
    self.contents = Bitmap.new(width - 32, row_max * 32)
  end
end
class Window_EquipSkillLeft < Window_Base
  include VIPArcher::Battle_Skill
  def initialize(actor, skill = nil)
    super(0, 64, 272, 192)
    self.contents = Bitmap.new(width - 32, height - 32)
    @actor, @skill = actor, skill
    refresh
  end
  def refresh
    self.contents.clear
    draw_actor_name(@actor, 4, 0)
    draw_actor_level(@actor, 132, 0)
    draw_skill_info unless @skill.nil?
  end
  def set_skill(skill)
    @skill = skill
    refresh
  end
  def draw_skill_info
    self.contents.font.color = system_color
    self.contents.draw_text(0,  32,  128, 32, '使用场合')
    self.contents.font.color = normal_color
    self.contents.draw_text(32, 64,  128, 32, SKILL_OCCASION[@skill.occasion])
    self.contents.font.color = system_color
    self.contents.draw_text(0,  96,  128, 32, '效果范围')
    self.contents.font.color = normal_color
    self.contents.draw_text(32, 128, 320, 32, SKILL_SCOPE[@skill.scope])
  end
end
class Window_EquipSkillSlot < Window_Selectable
  include VIPArcher::Battle_Skill
  attr_writer   :skill_info_window
  def initialize(actor, skill_index = 0)
    super(272, 64, 368, 192)
    @actor, self.index = actor, skill_index
    refresh
  end
  def data
    @actor.battle_skill
  end
  def item
    data[self.index] ? $data_skills[data[self.index]] : nil
  end
  def refresh
    @item_max = data.size
    create_contents
    self.contents.font.color = system_color
    Skills_Slot_Name.each_with_index do |name,id|
      self.contents.draw_text(4, 32 * id, 92, 32, name)
    end
    data.each_with_index do |skill_id,id|
      if skill_id.nil?
        self.contents.font.color = normal_color
        self.contents.draw_text(128 , 32 * id,192, 32, BLANK_TEXT)
      else
        draw_item_name($data_skills[skill_id], 128, 32 * id)
      end
    end
  end
  def update_help
    @help_window.set_text(item.nil? ? BLANK_HELP : item.description)
    @skill_info_window.set_skill(item) if @skill_info_window
  end
end
class Window_SkillItem < Window_Selectable
  include VIPArcher::Battle_Skill
  attr_writer   :skill_info_window
  def initialize(actor)
    super(0, 256, 640, 224)
    @actor, @column_max, self.active, self.index = actor, 2, false, -1
    refresh
  end
  def item
    @data[self.index] ? $data_skills[@data[self.index]] : nil
  end
  def refresh
    @data  = []
    skills = @actor.skills.select{|skill| !@actor.battle_skill.include?(skill)}
    skills.each{|skill| @data.push(skill) }
    @data.push(nil) # 添加[卸下装备]
    @item_max = @data.size
    create_contents
    @data.each_index{|index| draw_item(index)}
  end
  def draw_item(index)
    x = 4 + index % 2 * (288 + 32)
    y = index/ 2 * 32 #这残念的Sublime Text高亮=。=
    self.contents.font.color = normal_color
    if @data[index]
      skill  = $data_skills[@data[index]]
      bitmap = RPG::Cache.icon(skill.icon_name)
      self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24))
      self.contents.draw_text(x + 28, y, 212, 32, skill.name)
    else
      bitmap = RPG::Cache.icon(RELEASE_ICON) if RELEASE_ICON
      self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24)) if bitmap
      self.contents.draw_text(x + 28, y, 212, 32, RELEASE_TEXT)
    end
  end
  def update_help
    @help_window.set_text(item.nil? ? RELEASE_HELP : item.description)
    @skill_info_window.set_skill(item) if @skill_info_window
  end
end
class Window_Skill < Window_Selectable
  def refresh
    @data = []
    if $scene.instance_of?(Scene_Battle)
      @actor.battle_skill
    else
      @actor.skills
    end.each do |skill|
      @data.push($data_skills[skill]) unless skill.nil?
    end
    @item_max = @data.size
    create_contents unless @item_max.zero?
    @data.each_index{|index| draw_item(index) }
  end
end
class Scene_SetEquipSkill
  def initialize(actor_index = 0, skill_index = 0)
    @actor_index, @skill_index = actor_index, skill_index
  end
  def main
    @actor = $game_party.actors[@actor_index]
    create_all_window
    Graphics.transition
   [Graphics,Input,self].map(&:update) while $scene.equal?(self)
    Graphics.freeze
    dispose_all_window
  end
  def create_all_window
    @help_window      = Window_Help.new
    @right_window     = Window_EquipSkillSlot.new(@actor,@skill_index)
    @left_window      = Window_EquipSkillLeft.new(@actor,@right_window.item)
    @skillitem_window = Window_SkillItem.new(@actor)
    @right_window.help_window     = @help_window
    @skillitem_window.help_window = @help_window
    @right_window.skill_info_window     = @left_window
    @skillitem_window.skill_info_window = @left_window
  end
  def update
    update_all_windows
    return update_right if @right_window.active
    return update_item  if @skillitem_window.active
  end
  def update_right
    return scene_return     if Input.trigger?(Input::B)
    return on_slot_ok       if Input.trigger?(Input::C)
    return process_pagedown if Input.trigger?(Input::RIGHT)
    return process_pageup   if Input.trigger?(Input::LEFT)
  end
  def update_item
    return on_item_cancel if Input.trigger?(Input::B)
    return on_item_ok     if Input.trigger?(Input::C)
  end
  def on_item_ok
    $game_system.se_play($data_system.equip_se)
    skill = @skillitem_window.item
    @actor.add_battle_skill(skill.nil? ? 0 : skill.id,@right_window.index)
    @right_window.active     = true
    @skillitem_window.active = false
    @skillitem_window.index  = -1
    @right_window.refresh
    @skillitem_window.refresh
  end
  def on_item_cancel
    $game_system.se_play($data_system.cancel_se)
    @right_window.active     = true
    @skillitem_window.active = false
    @skillitem_window.index  = -1
  end
  def scene_return
    $game_system.se_play($data_system.cancel_se)
    $scene = Scene_Map.new
  end
  def on_slot_ok
    $game_system.se_play($data_system.decision_se)
    @equipskill_id           = @right_window.index
    @right_window.active     = false
    @skillitem_window.active = true
    @skillitem_window.index  = 0
  end
  def process_pageup
    $game_system.se_play($data_system.cursor_se)
    @actor_index += $game_party.actors.size - 1
    @actor_index %= $game_party.actors.size
    $scene = Scene_SetEquipSkill.new(@actor_index, @right_window.index)
  end
  def process_pagedown
    $game_system.se_play($data_system.cursor_se)
    @actor_index += 1
    @actor_index %= $game_party.actors.size
    $scene = Scene_SetEquipSkill.new(@actor_index, @right_window.index)
  end
  def update_all_windows
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      ivar.update if ivar.is_a?(Window)
    end
  end
  def dispose_all_window
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      ivar.dispose if ivar.is_a?(Window)
    end
  end
end
class Interpreter
  #--------------------------------------------------------------------------
  # ● 条件分支
  #--------------------------------------------------------------------------
  alias battle_skill_command_111 command_111
  def command_111
    result = false
    # 条件判定
    if [@parameters[0],@parameters[2]] == [4,2]
      actor = $game_actors[@parameters[1]]
      if actor != nil
        if $scene.instance_of?(Scene_Battle)
          result = (actor.battle_skill.include?(@parameters[3]))
        else
          result = (actor.skill_learn?(@parameters[3]))
        end
      end
      # 判断结果保存在 hash 中
      @branch[@list[@index].indent] = result
      # 判断结果为真的情况下
      if @branch[@list[@index].indent] == true
        # 删除分支数据
        @branch.delete(@list[@index].indent)
        # 继续
        return true
      end
      # 不符合条件的情况下 : 指令跳转
      return command_skip
    else
      battle_skill_command_111
    end
  end
end
