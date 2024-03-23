(ns tasks
  (:require [babashka.process :refer [shell sh]]))

(defn render []
  (shell "nickel export -f toml -o nix/starship/starship.toml ncl/starship.ncl"))

(defn switch [_m]
  (render)
  (shell "home-manager switch --flake ./#allancalix"))
              
