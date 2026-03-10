local function has_class(classes, target)
  for _, class_name in ipairs(classes) do
    if class_name == target then
      return true
    end
  end
  return false
end

function CodeBlock(el)
  if not FORMAT:match("latex") then
    return nil
  end

  if not has_class(el.classes, "graph") then
    return nil
  end

  local latex = table.concat({
    "\\begin{center}",
    "\\begin{adjustbox}{max width=\\linewidth,max totalheight=0.5\\textheight}",
    "\\begin{minipage}{\\linewidth}",
    "\\begin{Verbatim}[breaklines=true,breakanywhere=true,fontsize=\\scriptsize]",
    el.text,
    "\\end{Verbatim}",
    "\\end{minipage}",
    "\\end{adjustbox}",
    "\\end{center}"
  }, "\n")

  return pandoc.RawBlock("latex", latex)
end
