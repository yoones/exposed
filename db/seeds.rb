# coding: utf-8

(1..5).to_a.each { |n| Category.create!(name: "Name#{n}") }
