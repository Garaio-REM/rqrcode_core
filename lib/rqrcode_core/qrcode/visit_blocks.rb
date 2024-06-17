module RQRCodeCore
  class VisitBlocks
    def initialize(modules)
      @modules = modules

      raise ArgumentError, 'Low modules size' if modules.size < 3
    end

    # Calls {block} for each 3x3 block in {modules} with the values as it's arguments:
    # top_left, left, top_right, left, center, right, bottom_left, bottom, bottom_right
    def visit(&block)
      empty_row = Array.new(modules.size)

      [empty_row, *modules, empty_row].each_cons(3) do |above, current, below|
        visit_row(above, current, below, block)
      end
    end

    private

    attr_reader :modules, :demerit_points

    DEMERIT_THRESHOLD = 5

    def visit_row(above, current, below, visitor)
      columns = [[], *[above, current, below].transpose, []]

      blocks = columns.each_cons(3).map do |left, current, right|
        tl, l, bl = left
        t, c, b = current
        tr, r, br = right
        [tl, t, tr, l, c, r, bl, b, br]
      end

      blocks.each { visitor.call(*_1) }
    end
  end

  private_constant :VisitBlocks
end