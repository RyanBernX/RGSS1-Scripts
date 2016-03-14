#==============================================================================
# 本脚本来自[url]www.66RPG.com[/url]，使用和转载请保留此信息
#============================================================================== 
#
# 脚本功能：给不同物品显示不同颜色，类似暗黑破坏神，比如套装为绿色，超级为金色
#           可以更改的种类包括物品、防具、特技、武器。
#
# 使用方法：对于不想为白色表示的物品，在描述中的任意位置添加%color[6]，%color[4]一类的即可。
#           数字为颜色编号，和对话框中的一样。
# ——————————————————————————————————————
module RPG
  class Skill
    Regex_Color = /%color\[(\d+)\]/
    unless method_defined? :rb_description_20160314
      alias rb_description_20160314 description
      def description
        return rb_description_20160314.gsub(Regex_Color, "")
      end
    end
    def name_color_66RPG
      Regex_Color =~ @description
      return $1.to_i
    end
  end
  class Weapon
    Regex_Color = /%color\[(\d+)\]/
    unless method_defined? :rb_description_20160314
      alias rb_description_20160314 description
      def description
        return rb_description_20160314.gsub(Regex_Color, "")
      end
    end
    def name_color_66RPG
      Regex_Color =~ @description
      return $1.to_i
    end
  end
  class Item
    Regex_Color = /%color\[(\d+)\]/
    unless method_defined? :rb_description_20160314
      alias rb_description_20160314 description
      def description
        return rb_description_20160314.gsub(Regex_Color, "")
      end
    end
    def name_color_66RPG
      Regex_Color =~ @description
      return $1.to_i
    end
  end
  class Armor
    Regex_Color = /%color\[(\d+)\]/
    unless method_defined? :rb_description_20160314
      alias rb_description_20160314 description
      def description
        return rb_description_20160314.gsub(Regex_Color, "")
      end
    end
    def name_color_66RPG
      Regex_Color =~ @description
      return $1.to_i
    end
  end
end
 
# ——————————————————————————————————————
# 本脚本原创自[url]www.66rpg.com[/url]，转载请保留此信息
# ——————————————————————————————————————
class Window_Base < Window
  #--------------------------------------------------------------------------
  # ● 描绘物品名
  #     item : 物品
  #     x    : 描画目标 X 坐标
  #     y    : 描画目标 Y 坐标
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y)
    if item == nil
      return
    end
    bitmap = RPG::Cache.icon(item.icon_name)
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24))
    self.contents.font.color = text_color(item.name_color_66RPG)
    self.contents.draw_text(x + 28, y, 212, 32, item.name.to_s)
  end
end
 
# ——————————————————————————————————————
# 本脚本原创自[url]www.66rpg.com[/url]，转载请保留此信息
# ——————————————————————————————————————
class Window_Item
  #--------------------------------------------------------------------------
  # ● 描绘项目
  #     index : 项目编号
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    case item
    when RPG::Item
      number = $game_party.item_number(item.id)
    when RPG::Weapon
      number = $game_party.weapon_number(item.id)
    when RPG::Armor
      number = $game_party.armor_number(item.id)
    end
    if item.is_a?(RPG::Item) and
       $game_party.item_can_use?(item.id)
      self.contents.font.color = text_color(item.name_color_66RPG)
    else
      self.contents.font.color = disabled_color
    end
    x = 4 + index % 2 * (288 + 32)
    y = index / 2 * 32
    rect = Rect.new(x, y, self.width / @column_max - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    bitmap = RPG::Cache.icon(item.icon_name)
    opacity = self.contents.font.color == disabled_color ? 128 : 255
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(x + 28, y, 212, 32, item.name, 0)
    self.contents.draw_text(x + 240, y, 16, 32, ":", 1)
    self.contents.draw_text(x + 256, y, 24, 32, number.to_s, 2)
  end
end
 
# ——————————————————————————————————————
# 本脚本原创自[url]www.66rpg.com[/url]，转载请保留此信息
# ——————————————————————————————————————
class Window_EquipItem < Window_Selectable
  #--------------------------------------------------------------------------
  # ● 项目的描绘
  #     index : 项目符号
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    x = 4 + index % 2 * (288 + 32)
    y = index / 2 * 32
    case item
    when RPG::Weapon
      number = $game_party.weapon_number(item.id)
    when RPG::Armor
      number = $game_party.armor_number(item.id)
    end
    bitmap = RPG::Cache.icon(item.icon_name)
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24))
    self.contents.font.color = text_color(item.name_color_66RPG)
    self.contents.draw_text(x + 28, y, 212, 32, item.name, 0)
    self.contents.draw_text(x + 240, y, 16, 32, ":", 1)
    self.contents.draw_text(x + 256, y, 24, 32, number.to_s, 2)
  end
end
 
# ——————————————————————————————————————
# 本脚本原创自[url]www.66rpg.com[/url]，转载请保留此信息
# ——————————————————————————————————————
class Window_ShopBuy < Window_Selectable
  #--------------------------------------------------------------------------
  # ● 描绘羡慕
  #     index : 项目编号
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    # 获取物品所持数
    case item
    when RPG::Item
      number = $game_party.item_number(item.id)
    when RPG::Weapon
      number = $game_party.weapon_number(item.id)
    when RPG::Armor
      number = $game_party.armor_number(item.id)
    end
    # 价格在所持金以下、并且所持数不是 99 的情况下为普通颜色
    # 除此之外的情况设置为无效文字色
    if item.price <= $game_party.gold and number < 99
      self.contents.font.color = text_color(item.name_color_66RPG)
    else
      self.contents.font.color = disabled_color
    end
    x = 4
    y = index * 32
    rect = Rect.new(x, y, self.width - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    bitmap = RPG::Cache.icon(item.icon_name)
    opacity = self.contents.font.color == disabled_color ? 128 : 255
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(x + 28, y, 212, 32, item.name, 0)
    self.contents.draw_text(x + 240, y, 88, 32, item.price.to_s, 2)
  end
end
 
# ——————————————————————————————————————
# 本脚本原创自[url]www.66rpg.com[/url]，转载请保留此信息
# ——————————————————————————————————————
class Window_ShopSell < Window_Selectable
  #--------------------------------------------------------------------------
  # ● 描绘项目
  #     index : 项目标号
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    case item
    when RPG::Item
      number = $game_party.item_number(item.id)
    when RPG::Weapon
      number = $game_party.weapon_number(item.id)
    when RPG::Armor
      number = $game_party.armor_number(item.id)
    end
    # 可以卖掉的显示为普通颜色、除此之外设置成无效文字颜色
    if item.price > 0
      self.contents.font.color = text_color(item.name_color_66RPG)
    else
      self.contents.font.color = disabled_color
    end
    x = 4 + index % 2 * (288 + 32)
    y = index / 2 * 32
    rect = Rect.new(x, y, self.width / @column_max - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    bitmap = RPG::Cache.icon(item.icon_name)
    opacity = self.contents.font.color == disabled_color ? 128 : 255
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(x + 28, y, 212, 32, item.name, 0)
    self.contents.draw_text(x + 240, y, 16, 32, ":", 1)
    self.contents.draw_text(x + 256, y, 24, 32, number.to_s, 2)
  end
end
 
# ——————————————————————————————————————
# 本脚本原创自[url]www.66rpg.com[/url]，转载请保留此信息
# ——————————————————————————————————————
class Window_Skill
  #--------------------------------------------------------------------------
  # ● 描绘项目
  #     index : 项目编号
  #--------------------------------------------------------------------------
  def draw_item(index)
    skill = @data[index]
    if @actor.skill_can_use?(skill.id)
      self.contents.font.color = text_color(skill.name_color_66RPG)
    else
      self.contents.font.color = disabled_color
    end
    x = 4 + index % 2 * (288 + 32)
    y = index / 2 * 32
    rect = Rect.new(x, y, self.width / @column_max - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    bitmap = RPG::Cache.icon(skill.icon_name)
    opacity = self.contents.font.color == disabled_color ? 128 : 255
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(x + 28, y, 204, 32, skill.name, 0)
    self.contents.draw_text(x + 232, y, 48, 32, skill.sp_cost.to_s, 2)
  end
end
 
#==============================================================================
# 本脚本来自[url]www.66RPG.com[/url]，使用和转载请保留此信息
#==============================================================================
