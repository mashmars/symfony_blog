<?php
/**
 * Created by PhpStorm.
 * User: mash
 * Date: 2018/7/2
 * Time: 14:21
 */

namespace App\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\Extension\Core\Type\ResetType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\CheckboxType;
use Symfony\Component\Form\Extension\Core\Type\RadioType;

use App\Entity\Tag;
use Symfony\Component\OptionsResolver\OptionsResolver;

class TagType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('name',TextType::class,['label'=>'名称'])
            ->add('name1',TextareaType::class,['label'=>'名称','mapped'=>false,])
            ->add('name2',CheckboxType::class,['label'=>'名称','mapped'=>false,])
            ->add('name3',RadioType::class,['label'=>'名称','mapped'=>false,])
            ->add('submit',SubmitType::class);
    }
    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefaults(array(
            'data-class'    =>  Tag::class,
        ));
    }
}