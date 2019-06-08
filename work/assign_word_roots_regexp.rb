require "csv"

def assing_word_roots_regexp(roots)
  assinged_roots = []
  root_regexps = []
  roots.each do |root_info|
    root_word = root_info[0]
    root_pattern = []
    root_word.split(",").each do |root|
      if root.include? "/"
        base, *others = root.split("/")
        if others.length == 1 && others[0].length == 1
          # e.g. arch/i  → archi?
          root_pattern.append("#{base}#{others[0]}?")
        elsif others.all? { |other| other.length == 1 }
          # e.g. arch/a/i → arch[ai]?
          root_pattern.append("#{base}[#{others.join("")}]?")
        else
          # e.g. aud/i/io → aud(?:i|io)?
          root_pattern.append("#{base}(?:#{others.join("|")})?")
        end
      else
        root_pattern.append(root)
      end
    end
    assinged_roots << [root_pattern.join("|").delete(" ")] + root_info
  end
  assinged_roots
end

def assing_suffix_regexp(suffixes)
  assinged_suffixes = []
  suffix_regexp = ""

  suffixes.each do |suffix_info|
    suffix_pattern = []
    suffix_word = suffix_info[0]
    suffix_word.split(",").each do |suffix|
      suffix_pattern.append(suffix.delete("- "))
    end

    if suffix_pattern.length == 1
      suffix_regexp = "#{suffix_pattern[0]}$"
    else
      suffix_regexp = "(?:#{suffix_pattern.join("|")})$"
    end
    assinged_suffixes << [suffix_regexp] + suffix_info
  end
  assinged_suffixes
end

roots = CSV.read("work/roots.csv")
suffixes = CSV.read("work/suffixes.csv")

CSV.open("assigned_roots.csv", "wb") do |csv|
  assing_word_roots_regexp(roots).each do |line|
    csv << line
  end
end

CSV.open("assigned_suffixes.csv", "wb") do |csv|
  assing_suffix_regexp(suffixes).each do |line|
    csv << line
  end
end
