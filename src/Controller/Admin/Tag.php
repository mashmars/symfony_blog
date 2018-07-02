<?php
/**
 * Created by PhpStorm.
 * User: mash
 * Date: 2018/7/2
 * Time: 14:30
 */
namespace  App\Controller\Admin;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use App\Form\TagType;
use App\Entity\Tag as TagEntity;

/**
 * Class Category
 * @package App\Controller\Admin
 * @Route("/admin/tag")
 */
class Tag extends Controller
{
    /**
     * @Route("/add",name="tag_add",methods={"GET","POST"})
     */
    public function add(Request $request)
    {
        $entityManager = $this->getDoctrine()->getManager();
        $tag = new TagEntity();
        $form = $this->createForm(TagType::class,$tag);
        $form->handleRequest($request);
        if($form->isSubmitted() && $form->isValid()){
            $tag = $form->getData();
            $entityManager->persist($tag);
            $entityManager->flush();
            return new Response('添加成功');
        }
        return $this->render('admin/tag/add.html.twig',['form'=>$form->createView()]);
    }
}