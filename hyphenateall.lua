function hyphenate_always(head, tail)
   local n = head
   while n do
      if node.type(n.id) == 'glyph' and n.char == string.byte('-') then
         -- Insert an infinite penalty before, and a zero-width glue node after, the hyphen.
         -- Like writing "\nobreak-\hspace{0pt}" or equivalently "\penalty10000-\hskip0pt"
         local p = node.new(node.id('penalty'))
         p.penalty = 10000
         head, p = node.insert_before(head, n, p)
         local g = node.new(node.id('glue'))
         head, g = node.insert_after(head, n, g)
         n = g
      end
      n = n.next
   end
   lang.hyphenate(head, tail)
end

luatexbase.add_to_callback('hyphenate', hyphenate_always, 'Hyphenate even words containing hyphens')
