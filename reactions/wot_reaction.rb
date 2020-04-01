module Reactions
  class WotReaction
    class << self
      def attributes
        {
            contains: /wot in tarnation/i
        }
      end

      def obtain_random_image()
        images = [
          "https://i.pinimg.com/564x/61/c1/3f/61c13f4a64f31f0bf27774f25c6d009e.jpg",
          "https://i.pinimg.com/originals/e0/62/49/e06249cc5236d3465a80c42c83eb8b8c.jpg",
          "https://66.media.tumblr.com/82b58caf5075e442a85637fd4accd6bc/tumblr_ol48ljzJfd1up1aaeo1_500.jpg",
          "https://i.pinimg.com/originals/79/91/11/7991110c9747ecc0761529d52d9e5d00.jpg",
          "https://i.pinimg.com/564x/a6/46/64/a64664da1f573c9e3732d8cf30fda47f.jpg",
          "https://i.pinimg.com/564x/d6/af/a5/d6afa52ec518baf0f7268db23d62da54.jpg",
          "https://i.pinimg.com/564x/3d/d9/c1/3dd9c1dcdcd9d678a0c96acabd9228ee.jpg",
          "https://i.pinimg.com/564x/1e/5b/e7/1e5be747974346712ee4a81d3bdc0840.jpg",
          "https://i.pinimg.com/564x/0e/e0/e7/0ee0e7d3d905947f3a599f327a86ff27.jpg",
          "https://i.pinimg.com/564x/3b/bb/58/3bbb585d267110aafe9c7826c0fd68a7.jpg",
          "https://i.pinimg.com/564x/77/ce/31/77ce31093299c9ae29d9cfb5575b9b49.jpg",
          "https://i.pinimg.com/564x/3b/5d/4e/3b5d4ee3ae987fd70631e46825245049.jpg",
          "https://i.pinimg.com/564x/f0/52/6b/f0526b5f4d1b25d20b1f44fd4f01e0c1.jpg",
          "https://i.pinimg.com/564x/58/2f/b4/582fb4031395f66c27197e33856b2d04.jpg",
          "https://i.pinimg.com/564x/3d/50/71/3d5071cccd69339568f267f0f05be3aa.jpg",
          "https://i.pinimg.com/564x/06/69/fa/0669fa0b6072a9e4356cedda2c86d3d3.jpg",
          "https://i.pinimg.com/564x/7f/37/f0/7f37f079df5e8dd2ecedc54a73a3b424.jpg",
          "https://i.pinimg.com/564x/e1/6c/f5/e16cf5859087dd01b5e3aad38f813438.jpg",
          "https://i.pinimg.com/564x/d1/b5/55/d1b5557b36824ec81113dd69ae04fdb8.jpg",
          "https://i.pinimg.com/564x/45/44/10/454410716fdd537137c59f0495764b58.jpg",
          "https://i.pinimg.com/564x/e1/d4/46/e1d446eea2f38b6b8bb29160e6a11fdf.jpg",
          "https://external-preview.redd.it/dWhxkkbKfy9PhvGLAl51yHYNa18EdS1v3ipCtW-wmhA.jpg?width=640&crop=smart&auto=webp&s=7ab743b6d94780dd64a839a0a3a7c7ae571f9bfc",
        ]
        
        images.sample
      end

      def command(event)
        if Random.rand < 1
          event.respond obtain_random_image()
        end
      end
    end
  end
end
